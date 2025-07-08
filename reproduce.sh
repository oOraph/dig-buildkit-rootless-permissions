#!/bin/bash

# define DOCKER_IO_REPO env var

set -e -u -x

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

docker run -it --rm \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    -e BUILDKITD_FLAGS=--oci-worker-no-process-sandbox \
    -e DOCKER_CONFIG=/etc/docker \
    -v $SCRIPTPATH:/tmp/work \
    -v $HOME/.docker.test/:/etc/docker \
    --entrypoint buildctl-daemonless.sh \
    moby/buildkit:rootless \
    build \
    --frontend \
    dockerfile.v0 \
    --local context=/tmp/work/build \
    --local dockerfile=/tmp/work/no-copy \
    --output type=image,name=docker.io/$DOCKER_REPO/buildkit-generated:no-copy,push=true

docker run -it --rm \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    -e BUILDKITD_FLAGS=--oci-worker-no-process-sandbox \
    -e DOCKER_CONFIG=/etc/docker \
    -v $SCRIPTPATH:/tmp/work \
    -v $HOME/.docker.test/:/etc/docker \
    --entrypoint buildctl-daemonless.sh \
    moby/buildkit:rootless \
    build \
    --frontend \
    dockerfile.v0 \
    --local context=/tmp/work/build \
    --local dockerfile=/tmp/work/copy-simple \
    --output type=image,name=docker.io/$DOCKER_REPO/buildkit-generated:copy-simple,push=true

docker run -it --rm \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    -e BUILDKITD_FLAGS=--oci-worker-no-process-sandbox \
    -e DOCKER_CONFIG=/etc/docker \
    -v $SCRIPTPATH:/tmp/work \
    -v $HOME/.docker.test/:/etc/docker \
    --entrypoint buildctl-daemonless.sh \
    moby/buildkit:rootless \
    build \
    --frontend \
    dockerfile.v0 \
    --local context=/tmp/work/build \
    --local dockerfile=/tmp/work/copy-link \
    --output type=image,name=docker.io/$DOCKER_REPO/buildkit-generated:copy-link,push=true

# Show permissions are broken
docker run -it --rm  $DOCKER_REPO/buildkit-generated:copy-simple /bin/bash -c 'ls -alhd /tmp'

docker run -it --rm  $DOCKER_REPO/buildkit-generated:copy-link /bin/bash -c 'ls -alhd /tmp'

docker run -it --rm  $DOCKER_REPO/buildkit-generated:no-copy /bin/bash -c 'ls -alhd /tmp'

