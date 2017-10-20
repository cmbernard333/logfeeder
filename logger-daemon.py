#!/usr/bin/env python
import argparse
import logging
import logging.handlers
import os
import signal
import sys
from datetime import datetime
from time import sleep

log_level_map = {
    0 : logging.CRITICAL,
    1 : logging.ERROR,
    2 : logging.WARNING,
    3 : logging.INFO,
    4 : logging.DEBUG,
}

# set the flag for the infinite loop
daemon_stop = False

def signal_handler(signal, frame):
    global daemon_stop # since this is caught out of frame it has to be global
    print('daemon_stop set to {0}'.format(str(daemon_stop)))
    daemon_stop = True


signal.signal(signal.SIGINT, signal_handler)

def setup_logging(addr,loglevel,name):
    log = logging.getLogger(name)
    log.setLevel(loglevel)
    handler = logging.handlers.SysLogHandler(address=addr)
    formatter = logging.Formatter('%(module)s.%(funcName)s: %(message)s')
    handler.setFormatter(formatter)
    log.addHandler(handler)
    return log


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-l","--log_level", help="The log level to log at", nargs='?', const=1, type=int, default=4)
    parser.add_argument("-a","--address", help="Address to logging location", nargs='?', const=1, type=str, default='/dev/log')
    parser.add_argument("-n","--name", help="The name used by the logger", nargs='?', const=1, type=str, default=__name__)
    parser.add_argument("-v","--verbose", help="Enable verbose logging", action="store_true", default=False)
    parser.add_argument("-i","--interval", help="Interval to log messages", nargs='?', const=1, type=int, default=1)
    parser.add_argument("-m","--messages", help="The number of messages to generate", nargs='?', cont=1, type=int, default=1)
    return parser.parse_args()

def do_logging(log,loglevel,interval=1,messages=1):
    while daemon_stop == False:
        for i in range(0,messages):
            log.log(loglevel,"{} This is a test log message".format(datetime.now()))
        if interval > 0:
            sleep(interval)
    log.log(logging.CRITICAL,"Shutting down!")

def main():
    args = get_args()
    verbose = args.verbose
    if verbose == True:
        print(args)
    log = setup_logging(args.address, args.log_level, args.name)
    do_logging(log,args.log_level, args.interval)
    sys.exit(0)

if __name__ == "__main__":
    main()
