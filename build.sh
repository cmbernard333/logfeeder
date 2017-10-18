#!/bin/bash
TAGS=()
LATEST_TAG=automox/logfeeder:latest
RUN=false
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

docker build --no-cache ${TAGS_STR} -f $DOCKERFILE .
if [ "$RUN" = "true" ]; then
	# --volumes-from attachs to the volumes presented by logdemon in its Dockerfile
	docker run -d --name logfeeder --volumes-from logdemon $LATEST_TAG 
fi

