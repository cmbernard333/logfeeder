#!/bin/bash
if [ -e /var/run/rsyslog/dev ]; then
    ln -sf /var/run/rsyslog/dev/log /dev/log
fi
# configurable logging interval
if [ -n "$LOGGER_INTERVAL" ]; then
    LOGGER_ARG="-i $LOGGER_INTERVAL"
fi
exec "$@" "$LOGGER_ARG"
