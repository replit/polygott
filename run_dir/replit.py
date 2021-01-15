send_msg = None

def init(send):
    global send_msg
    send_msg = send

def clear():
    send_msg("clearConsole")
