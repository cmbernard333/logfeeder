# Create a minimal ubuntu image
# Latest ubuntu LTS
# Installs the logger binary (/usr/bin/logger), python3 (/usr/bin/python3), and env (/usr/bin/env)
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y bsdutils coreutils python3
COPY logger-daemon.py /usr/local/bin/logger-daemon
COPY logger-entrypoint.sh /
ENTRYPOINT [ "/logger-entrypoint.sh" ]
CMD ["/usr/bin/python3","/usr/local/bin/logger-daemon"]
