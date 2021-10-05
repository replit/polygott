import os
import json
import select
import socket
import subprocess
import sys
import tempfile

import remotedebugger


if sys.version_info[0] == 2:
    raise ValueError("Wrong Python version! This script is for Python 3.")


class DebuggerSocket():
    def __init__(self, socket):
        self.socket = socket
        self.buffer = b''

    def fileno(self):
        return self.socket.fileno()

    def parse_message(self):
        if b'\n' in self.buffer:
            data, self.buffer = self.buffer.split(b'\n', 1)
            msg = json.loads(data.decode('utf8'))
            return msg

    def on_read(self):
        """Reads bytes off the wire and returns all contained messages"""
        data = self.socket.recv(1024)
        if not data:
            raise subprocess.SubprocessError('Subprocess disconnected')
        self.buffer += data
        msgs = []
        while True:
            msg = self.parse_message()
            if msg:
                msgs.append(msg)
            else:
                break
        return msgs


class DebuggerProcess(object):
    def __init__(self, program):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.filename = os.path.join(self.temp_dir.name, 'usermodule.py')
        with open(self.filename, 'w') as f:
            f.write(program)

        host, port = ('127.0.0.1', 1234)
        listen_socket = socket.socket()
        listen_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)
        listen_socket.bind((host, port))
        listen_socket.listen(1)

        self.p = subprocess.Popen([
                sys.executable,
                os.path.abspath(remotedebugger.__file__),
                '--host', host,
                '--port', str(port),
                '--connect',
                '--file',
                self.filename,
            ],
            stdin=subprocess.PIPE,
            # use real stdout/stderr for printing errors
        )

        self.messages = []
        self.done = False
        self.s, _ = listen_socket.accept()
        listen_socket.close()
        self.debuggerSocket = DebuggerSocket(self.s)
        self.has_already_stepped_once = False

    def send(self, kind):
        msg = json.dumps({'kind': kind}).encode('utf8')+b'\n'
        self.s.sendall(msg)

    def step(self):
        """Yields messages until current stack is returned.

        Yielded messages will be of one of these types
            * {kind: 'stdout', data: 'data'} when the process writes to stdout
            * (kind: 'stderr', data: 'data') when the process writes to stderr
            * (kind: 'error', data: 'Traceback ...'}

        The first step does not step, it just returns the first stack.
        """
        if self.done:
            return 'done'
        elif self.has_already_stepped_once:
            self.send('step')
        else:
            self.has_already_stepped_once = True

        yield from self.update_stack()
        return 'done' if self.done else self.stack

    def update_stack(self):
        stack_or_done = yield from self._get_stack()
        if stack_or_done == 'done':
            self.done = True
            self.stack = []
        else:
            self.stack = stack_or_done

    def _get_stack(self):
        """Returns a list of stack frame {lineno, functionName}, or 'done'"""
        for kind, payload in self.get_subproc_msgs('stack'):
            if kind == 'stack':
                stack = payload
            elif kind == 'stdout':
                yield (kind, payload)
            elif kind == 'stderr':
                yield (kind, payload)
            elif kind == 'done':
                return 'done'
            elif kind == 'error':
                yield ('error', payload)
                return 'done'
            else:
                raise ValueError("Unexpected message: "+repr((kind, payload)))
        return stack

    def get_subproc_msgs(self, kind='stack'):
        """Yields subprocess messages until the requested message is received.

        This method also forwards stdin bytes to the debugger subprocess,
        so it's important to use it instead of a (blocking) self.s.recv()
        """
        readers = [self.debuggerSocket, sys.stdin]
        while True:
            rs, _, _ = select.select(readers, [], [])
            for reader in rs:
                if reader is sys.stdin:
                    self.p.stdin.write(bytearray(reader.readline(), 'utf-8'))
                elif reader is self.debuggerSocket:
                    msgs = self.debuggerSocket.on_read()
                    for msg in msgs:
                        yield (msg['kind'], msg['data'])
                        if msg['kind'] == kind:
                            return

    def cleanup(self):
        self.s.close()
        self.p.stdin.close()
        self.p.kill()
        self.temp_dir.cleanup()

    def __enter__(self):
        return self

    def __exit__(self, *args):
        self.cleanup()

    def __del__(self):
        self.cleanup()
