# -*- coding: utf-8 -*-

import json
import os
import sys
import traceback
from parser import parse

import replit
import subprocessdebugger

globals = {'__builtins__': __builtins__, '__name__': __name__}
pid1_out = os.fdopen(201, 'w')
pid1_in = os.fdopen(200, 'r')

def send_msg(command, data="", error=""):
    pid1_out.write(json.dumps({
        "command": command,
        "data": data,
        "error": error
    }) + "\n")
    pid1_out.flush()

replit.init(send_msg)

def run(code):
    res = None
    err = None
    try:
        if code.find('\n') > -1 or code == '':
            compiled = compile(code, 'python', 'exec')
        else:
            try:
                compiled = compile(code, 'python', 'eval')
            except:
                compiled = compile(code, 'python', 'single')
        res = eval(compiled, globals)
    except Exception:
        err_type, value, tb = sys.exc_info()
        sys.last_type = err_type
        sys.last_value = value
        sys.last_traceback = tb
        slist = traceback.extract_tb(tb)
        del slist[:1]
        stack = traceback.format_list(slist)
        stack = list(filter(lambda e: e.find('File "/') == -1, stack))
        stack.insert(0, "Traceback (most recent call last):\n")
        stack[len(stack):] = traceback.format_exception_only(err_type, value)
        err = ''.join(stack)

    return res, err

debugger = None

send_msg("ready")
while True:
    line = pid1_in.readline()
    if 0 == len(line):
        raise EOFError

    # This handles any extraneous input we get from the user.
    # This happens when they think their program expects input
    # when it doesn't
    try:
        msg = json.loads(line)
    except ValueError:
        continue
    if type(msg) != dict:
        continue

    if msg["command"] == "eval":
        code = msg["data"] if "data" in msg else ""
        res, err = run(code)
        sys.stdout.flush()
        sys.stderr.flush()
        send_msg("result", repr(res), err if err else "")

    elif msg["command"].startswith("debugger"):
        if msg["command"] == 'debuggerStart':
            if debugger is not None:
                debugger.cleanup()
            debugger = subprocessdebugger.DebuggerProcess(msg["data"])
            send_msg('debuggerReady')
        elif msg["command"] == 'debuggerStep':
            if not debugger:
                continue
            for kind, payload in debugger.step():
                if kind == 'stdout':
                    send_msg('output', payload)
                elif kind == 'stderr':
                    send_msg('output', payload)
                elif kind == 'error':
                    send_msg('debuggerBreak', json.dumps({
                        'stack': [],
                        'done': True
                    }))
                    send_msg('result', '', payload)
                    break  # don't run the for-else else clause
                else:
                    raise ValueError("can't handle " + kind + "message")
            else:  # this else clause runs if the for loop didn't break
                send_msg('debuggerBreak', json.dumps({
                    'stack': debugger.stack,
                    'done': debugger.done
                }))
                if debugger.done:
                    send_msg('result', 'None')
        else:
            raise ValueError('UnknownDebuggerCommand')

    elif msg["command"] == "parse":
        program = msg["data"]

        try:
            parsed_ast = parse(program)
        except Exception as err:
            send_msg("parseResult", "", str(err))
        else:
            send_msg("parseResult", parsed_ast)
    else:
        raise RuntimeError("Invalid command")
