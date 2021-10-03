#!/bin/bash

set -e

# TaskID of a task you want to debug locally.
TASKID="$1"

# The taskcluster CLI
taskcluster task def "${TASKID}" > "${TASKID}"

# "jq" from your distro. This is the task that built the docker image
IMAGE_TASKID=$(jq -r '.payload.image.taskId' < "$TASKID")

# Grab the image and extract its manifest
wget -O /tmp/image.tar.zst "https://firefox-ci-tc.services.mozilla.com/api/queue/v1/task/${IMAGE_TASKID}/artifacts/public/image.tar.zst"
tar xvf /tmp/image.tar.zst manifest.json

# This is works, but could be improved
IMAGE_TAG=$(jq -r '.[].RepoTags[0]' manifest.json)
IMAGE_NAME=$(echo ${IMAGE_TAG} | sed -e 's%^.*/%%' -e 's%:latest$%%')
# CONTAINER_NAME needs to be unique.
CONTAINER_NAME="container_$(echo "$IMAGE_NAME" | sed 's/^.*://')"

# Not sure exactly why I abandoned this?
# ( cd "$MOZSRC"; ./mach -v taskcluster-load-image --task-id "$IMAGE_TASKID" )

zstdcat /tmp/image.tar.zst | docker image load
rm -f manifest.json /tmp/image.tar.zst

# This check just doesn't work, or checks the wrong thing... either way
# half the time when I run this it fails on container create below...
_exists=$(docker container ls -a -q -f name="${CONTAINER_NAME}")
if [[ -n "$_exists" ]]; then docker container rm "${_exists}"; fi

docker container create -ti --name "$CONTAINER_NAME" "$IMAGE_NAME" bash --login
# Copy docker_run_local.py and the task definition into the container for later
docker cp /home/rob/moz/robtools/docker_run_local.py ${CONTAINER_NAME}:/builds/worker/docker_run_local.py
docker cp $TASKID ${CONTAINER_NAME}:/builds/worker

# This keeps the container running, in an odd window that I won't accidentally
# close, killing the container.
uxterm -e docker start -i -a "$CONTAINER_NAME" &

rm  "${TASKID}"
#sleep 5

# Can this just get added to debian-raw?
docker exec -i "$CONTAINER_NAME" apt install vim

# I echo the command to run the task instead of just running it because
# there's usually some manual steps that vary depending on what I am working on
echo 'docker exec  -i "$CONTAINER_NAME"  /builds/worker/docker_run_local.py < "$TASKJSON"'

# run-task (I think?) will blow away any source checkouts and fetches when it
# exits. I tend to hack it up not to. Perhaps an argument to not do that is in
# order?

