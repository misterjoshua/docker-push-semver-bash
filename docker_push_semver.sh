#!/usr/bin/env bash

function dockerPushSemver() {
    DOCKER_REPO="$1"
    VERSION=$2

    source <(curl -s https://raw.githubusercontent.com/cloudflare/semver_bash/master/semver.sh)

    MAJOR=0
    MINOR=0
    PATCH=0
    SPECIAL=""
    semverParseInto "$VERSION" MAJOR MINOR PATCH SPECIAL

    docker tag $DOCKER_REPO:latest $DOCKER_REPO:$VERSION
    docker push $DOCKER_REPO:latest
    docker push $DOCKER_REPO:$VERSION

    if [ -z "$SPECIAL" ]; then
        docker tag $DOCKER_REPO:latest $DOCKER_REPO:$MAJOR.$MINOR.$PATCH
        docker tag $DOCKER_REPO:latest $DOCKER_REPO:$MAJOR.$MINOR
        docker tag $DOCKER_REPO:latest $DOCKER_REPO:$MAJOR
        docker push $DOCKER_REPO:$MAJOR.$MINOR.$PATCH
        docker push $DOCKER_REPO:$MAJOR.$MINOR
        docker push $DOCKER_REPO:$MAJOR
    fi
}

if [ "___docker_push_semver.sh" == "___`basename $0`" ]; then
    set -e
    dockerPushSemver $1 $2
fi