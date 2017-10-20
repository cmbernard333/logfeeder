#!/bin/bash
if [ -e /var/run/rsyslog/dev ]; then
    ln -sf /var/run/rsyslog/dev/log /dev/log
fi
ARGS=()
# configurable logging interval
if [ -n "$LOGGER_INTERVAL" ]; then
    ARGS+=("-i $LOGGER_INTERVAL")
fi
# configurable logging messages sent per interval
if [ -n "$LOGGER_MESSAGES" ]; then
    ARGS+=("-m $LOGGER_MESSAGES")
fi
ARGS+=("-v")

exec "$@" "${ARGS[@]}"
