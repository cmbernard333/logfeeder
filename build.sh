#!/bin/bash
docker stop logfeeder && docker rm logfeeder
docker build --no-cache -t automox/logfeeder:latest -f Dockerfile .
# --volumes-from attachs to the volumes presented by logdemon in its Dockerfile
docker run -d --name logfeeder --volumes-from logdemon automox/logfeeder:latest
# run in second container - not first one
docker exec -it logfeeder bash -c "ln -sf /var/run/rsyslog/dev/log /dev/log" 

