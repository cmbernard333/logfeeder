# Create a minimal ubuntu image
# Latest ubuntu LTS
# Installs the logger binary (/usr/bin/logger), python3 (/usr/bin/python3), and env (/usr/bin/env)
FROM debian:jessie
RUN apt-get update && apt-get install -y bsdutils coreutils python3
COPY logger-daemon.py /usr/local/bin/logger-daemon
COPY logger-entrypoint.sh /
ENTRYPOINT [ "bash","/logger-entrypoint.sh" ]
CMD ["python3","/usr/local/bin/logger-daemon"]
