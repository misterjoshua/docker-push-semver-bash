#!/usr/bin/env bash

function dockerPushSemverUsage() {
    echo -e "usage: docker_push_semver.sh [-d] [-b <tag>] [-v <variation>] <docker_repo> <semantic_version>"
    echo -e "  Tag and push docker images for major and minor versions of a locally built"
    echo -e "  image if the version number provided doesn't include a pre-release tag."
    echo -e ""
    echo -e "  Options:"
    echo -e "    -b tag        Specify a locally-build image tag rather than 'latest'"
    echo -e "    -d            Don't push the local tag"
    echo -e "    -h            Show help"
    echo -e "    -v variation  Append a variation suffix to the tagged images"
}

function dockerPushSemver() {
    LOCAL_TAG=latest
    VARIATION=""
    PUSH_LOCAL_TAG=yes
    
    while getopts "dhb:v:" OPT; do
        case "$OPT" in
            b) LOCAL_TAG=$OPTARG ;;
            d) PUSH_LOCAL_TAG=no ;;
            v) VARIATION=$OPTARG ;;
            *)
                dockerPushSemverUsage
                return
        esac
    done

    shift $((OPTIND - 1))
    
    DOCKER_REPO="$1"
    VERSION="$2"

    if [[ -z "$DOCKER_REPO" || -z "$VERSION" ]]; then
        dockerPushSemverUsage
        return
    fi

    # echo "LOCAL_TAG: $LOCAL_TAG"
    # echo "VARIATION: $VARIATION"
    # echo "DOCKER_REPO: $DOCKER_REPO"
    # echo "VERSION: $VERSION"

    # Parse semvers
    MAJOR=$(cut -d. -f1 <<<$VERSION)
    MINOR=$(cut -d. -f2 <<<$VERSION)
    REST=$(cut -d. -f3 <<<$VERSION)
    PATCH=$(cut -sd- -f1 <<<$REST)
    SPECIAL=$(cut -sd- -f2- <<<$REST)
    PATCH=${PATCH:=$REST}

    if [ "$PUSH_LOCAL_TAG" = "yes" ]; then
        # Push the latest tag
        docker push $DOCKER_REPO:$LOCAL_TAG
    fi
    
    # Tag and push this version
    docker tag $DOCKER_REPO:$LOCAL_TAG $DOCKER_REPO:$VERSION$VARIATION
    docker push $DOCKER_REPO:$VERSION$VARIATION

    # If there's no special version (i.e., 1.2.3-beta123), push minor and major tags
    if [ -z "$SPECIAL" ]; then
        docker tag $DOCKER_REPO:$LOCAL_TAG $DOCKER_REPO:$MAJOR.$MINOR$VARIATION
        docker tag $DOCKER_REPO:$LOCAL_TAG $DOCKER_REPO:$MAJOR$VARIATION
        docker push $DOCKER_REPO:$MAJOR.$MINOR$VARIATION
        docker push $DOCKER_REPO:$MAJOR$VARIATION
    fi
}

if [ "___docker_push_semver.sh" == "___`basename -- $0`" ]; then
    set -e
    dockerPushSemver $*
fi