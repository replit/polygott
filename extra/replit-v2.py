import sys
def clear():
    sys.stdout.write(chr(27) + '[3;J' + chr(27) + "[H" + chr(27) + '[2J')
