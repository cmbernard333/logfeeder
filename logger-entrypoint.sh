#!/bin/bash
if [ -e /var/run/rsyslog/dev/log ]; then
    ln -sf /var/run/syslog/dev/log /dev/log
fi
exec "$@"
