#!/usr/bin/env bash

function dockerPushSemver() {
    DOCKER_REPO="$1"
    VERSION=$2
    
    LATEST=latest
    [ ! -z "$3" ] && LATEST=$3
    
    VARIATION=""
    [ ! -z "$4" ] && VARIATION=$4

    # Parse semvers
    MAJOR=$(cut -d. -f1 <<<$VERSION)
    MINOR=$(cut -d. -f2 <<<$VERSION)
    REST=$(cut -d. -f3 <<<$VERSION)
    PATCH=$(cut -sd- -f1 <<<$REST)
    SPECIAL=$(cut -sd- -f2- <<<$REST)
    PATCH=${PATCH:=$REST}

    # Push the latest tag
    docker push $DOCKER_REPO:$LATEST
    
    # Tag and push this version
    docker tag $DOCKER_REPO:$LATEST $DOCKER_REPO:$VERSION
    docker push $DOCKER_REPO:$VERSION$VARIATION

    # If there's no special version (i.e., 1.2.3-beta123), push minor and major tags
    if [ -z "$SPECIAL" ]; then
        docker tag $DOCKER_REPO:$LATEST $DOCKER_REPO:$MAJOR.$MINOR$VARIATION
        docker tag $DOCKER_REPO:$LATEST $DOCKER_REPO:$MAJOR$VARIATION
        docker push $DOCKER_REPO:$MAJOR.$MINOR$VARIATION
        docker push $DOCKER_REPO:$MAJOR$VARIATION
    fi
}

if [ "___docker_push_semver.sh" == "___`basename $0`" ]; then
    set -e
    dockerPushSemver $1 $2
fi