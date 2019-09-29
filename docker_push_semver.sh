#!/usr/bin/env bash

function dockerPushSemver() {
    DOCKER_REPO="$1"
    VERSION=$2

    # Parse semvers
    MAJOR=$(cut -d. -f1 <<<$VERSION)
    MINOR=$(cut -d. -f2 <<<$VERSION)
    REST=$(cut -d. -f3 <<<$VERSION)
    PATCH=$(cut -sd- -f1 <<<$REST)
    SPECIAL=$(cut -sd- -f2- <<<$REST)
    PATCH=${PATCH:=$REST}

    docker tag $DOCKER_REPO:latest $DOCKER_REPO:$VERSION
    docker push $DOCKER_REPO:latest
    docker push $DOCKER_REPO:$VERSION

    if [ -z "$SPECIAL" ]; then
        docker tag $DOCKER_REPO:latest $DOCKER_REPO:$MAJOR.$MINOR
        docker tag $DOCKER_REPO:latest $DOCKER_REPO:$MAJOR
        docker push $DOCKER_REPO:$MAJOR.$MINOR
        docker push $DOCKER_REPO:$MAJOR
    fi
}

if [ "___docker_push_semver.sh" == "___`basename $0`" ]; then
    set -e
    dockerPushSemver $1 $2
fi