#!/bin/bash
TAGS=()
LATEST_TAG=automox/logfeeder:latest
RUN=false
CACHE=""
ERASE=""
for i in "$@"
do
case ${i} in
    -t=*|--tag=*)
    TAGS+=("${i#*=}")
    shift # past argument=value
    ;;
    -r|--run)
    RUN=true
    shift
    ;;
    -e|--erase)
    ERASE="--rm"
    shift
    ;;
    -n|--no-cache)
    CACHE="--no-cache"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
done

# default values
TAGS+=("-t $LATEST_TAG")
DOCKERFILE=Dockerfile
TAGS_STR=$( IFS=$' '; echo "${TAGS[*]}" )

docker stop logfeeder && docker rm logfeeder
docker build ${CACHE} ${TAGS_STR} -f $DOCKERFILE .
if [ "${RUN}" = "true" ]; then
    # mounting docker volume 'rsyslog-remote' to /var/run/rsyslog/dev to get access to the 'log' socket
    docker run ${ERASE} -d --name logfeeder --mount src=rsyslog-remote,dst=/var/run/rsyslog $LATEST_TAG
fi

