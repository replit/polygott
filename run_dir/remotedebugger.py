# encoding: utf8
"""
A debugger that communicates over a socket for debugging commands,
"""

import argparse
import bdb
import json
import os
import socket
import sys


if sys.version_info[0] == 2:
    raise ValueError("Wrong Python version! Only for use with Python 3.")


class MyStdout(object):
    def __init__(self, stream, on_write):
        self.on_write = on_write
        self.orig_stream = stream

    def write(self, s):
        self.on_write(s)

    def __getattr__(self, name):
        return getattr(self.orig_stream, name)


class RemoteDebugger(bdb.Bdb):
    def __init__(self, host, port, server=True, connection=None):
        """Wait for socket connection then create a debugger."""

        if connection:
            self.connection = connection
        elif server:
            listen_socket = socket.socket()
            listen_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)
            listen_socket.bind((host, port))
            listen_socket.listen(1)
            self.connection, address = listen_socket.accept()
            listen_socket.close()
        else:
            self.connection = socket.socket()
            self.connection.connect((host, port))

        bdb.Bdb.__init__(self, skip=None)
        self.receive_buffer = b''
        self.send_buffer = b''

        self.filename_blacklist = [self.canonic(__file__)]
        # if any frame of a stack is in one of these files, skip related events

        self.top_frame_filename_whitelist = ['<string>']
        # if the topmost frame is not one of these files, skip related events

    def getline(self, filename, lineno, globals):
        if filename == '<string>':
            return self.code_lines[lineno-1]
        import linecache
        return linecache.getline(filename, lineno, globals)

    def extract_stack(self, frame):
        stack = []
        for frame, lineno in self.get_stack(frame, None)[0]:
            filename = self.canonic(frame.f_code.co_filename)
            line = self.getline(filename, frame.f_lineno, frame.f_globals)
            if filename in self.filename_blacklist:
                return None
            stack.append({
                'lineno':       lineno,
                'functionName': frame.f_code.co_name or '???',
                'filename':     filename,
                'line':         line.strip(),
            })
        if stack[-1]['filename'] not in self.top_frame_filename_whitelist:
            return None

        keys_to_keep = ['lineno', 'functionName']
        frames_to_keep = stack[1:]
        return [{k: s[k] for k in keys_to_keep} for s in frames_to_keep]

    # these methods are called by parent class bdb.Bdb

    def user_call(self, frame, args):
        """This method is called when there is the remote possibility
        that we ever need to stop in this function."""
        # Enabled in order to get the extra step of the def line of
        # a function definition when calling a function
        stack = self.extract_stack(frame)
        if stack is None:
            return  # extract_stack returns None if not a user step

        self.send('stack', stack)
        self.receive('step')

    def user_line(self, frame):
        """This method is called when we stop or break at this line."""
        stack = self.extract_stack(frame)
        if stack is None:
            return  # extract_stack returns None if not a user step

        self.send('stack', stack)
        self.receive('step')

    def user_return(self, frame, return_value):
        """This method is called when a return trap is set here."""
        # This would be useful for tracing return values up the stack
        # or for watching exceptions propogate up the stack

    def user_exception(self, frame, exc_info):
        """This method is called if an exception occurs,
        but only if we are to stop at or just below this level."""
        # This would be useful if we wanted to show the current exception
        # or just wanted to report the line an exception occurred on after
        # the exception was raised.

    # communication with controlling process

    def send(self, kind, data=None):
        msg = json.dumps({'kind': kind, 'data': data}).encode('utf8') + b'\n'
        self.connection.sendall(msg)

    def receive(self, kind=None):
        while True:
            data = self.connection.recv(1024)
            if not data:
                sys.exit()  # disconnected from controller
            self.receive_buffer += data
            if b'\n' in self.receive_buffer:
                data, self.receive_buffer = self.receive_buffer.split(b'\n', 1)
                msg = json.loads(data.decode('utf8'))
                if kind is not None and msg['kind'] != kind:
                    raise ValueError('Debugger received wrong message type')
                return msg

    def run(self, cmd, globals=None, locals=None):
        self.code_lines = cmd.split('\n')
        try:
            bdb.Bdb.run(self, cmd, globals=globals, locals=locals)
        except SystemExit:
            # that's probably fine
            self.send('done')
        except Exception:
            import traceback
            self.send('error', traceback.format_exc())
            self.send('done')
        else:
            self.send('done')

    def stdout_write(self, s):
        self.send('stdout', s)

    def stderr_write(self, s):
        # stderr is useful for debugging, so also write to real stderr
        import sys
        sys.__stdout__.write(s)
        self.send('stderr', s)


def exists(filename):
    if not os.path.exists(filename):
        raise ValueError('File does not exist')
    return filename


class RedirectedStdoutStderr:
    def __init__(self, on_stdout_write, on_stderr_write):
        self.on_stdout_write = on_stdout_write
        self.on_stderr_write = on_stderr_write

    def __enter__(self):
        self.orig_stdout = sys.stdout
        self.orig_stderr = sys.stderr
        sys.stdout = MyStdout(sys.stdout, self.on_stdout_write)
        sys.stderr = MyStdout(sys.stdin, self.on_stderr_write)

    def __exit__(self, *args):
        sys.stdout = self.orig_stdout
        sys.stderr = self.orig_stderr


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', default='127.0.0.1')
    parser.add_argument('-p', '--port', default=1234, type=int)
    parser.add_argument('--connect', default=False, action='store_true',
                        help='Instead of listening on this host/port, '
                             'connect to a server listening on them.')
    source_group = parser.add_mutually_exclusive_group(required=True)
    source_group.add_argument('-f', '--file', dest='mainpyfile', type=exists)
    source_group.add_argument('-c', '--code', dest='code')

    arguments = parser.parse_args()

    debugger = RemoteDebugger(host=arguments.host, port=arguments.port,
                              server=not arguments.connect)

    if arguments.mainpyfile:
        with open(arguments.mainpyfile) as f:
            src = f.read()
    else:
        src = arguments.code

    with RedirectedStdoutStderr(debugger.stdout_write, debugger.stderr_write):
        debugger.run(src)


if __name__ == '__main__':
    main()
