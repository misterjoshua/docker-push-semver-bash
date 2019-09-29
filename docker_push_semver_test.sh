#!/usr/bin/env bash

set -ex
source docker_push_semver.sh

function docker() {
    echo $*
}
function die() {
    echo "$1"
    exit 1
}

DOCKER_REPO="misterjoshua/docker-push-semver"

OUTPUT=$(dockerPushSemver "$DOCKER_REPO" "1.2.3-test")
grep "push.*$DOCKER_REPO:latest$" <<<$OUTPUT >/dev/null || die "It didn't push :latest"
grep "push.*$DOCKER_REPO:1.2.3-test$" <<<$OUTPUT >/dev/null || die "It didn't push :1.2.3-test"
grep "push.*$DOCKER_REPO:1.2.3$" <<<$OUTPUT >/dev/null && die "It pushed a semver with a SPECIAL"
grep "push.*$DOCKER_REPO:1.2$" <<<$OUTPUT >/dev/null && die "It pushed a semver with a SPECIAL"
grep "push.*$DOCKER_REPO:1$" <<<$OUTPUT >/dev/null && die "It pushed a semver with a SPECIAL"

OUTPUT=$(dockerPushSemver "$DOCKER_REPO" "1.2.3")
grep "push.*$DOCKER_REPO:latest$" <<<$OUTPUT >/dev/null || die "It didn't push :latest"
grep "push.*$DOCKER_REPO:1.2.3$" <<<$OUTPUT >/dev/null || die "It didn't push :1.2.3"
grep "push.*$DOCKER_REPO:1.2$" <<<$OUTPUT >/dev/null || die "It didn't push :1.2"
grep "push.*$DOCKER_REPO:1$" <<<$OUTPUT >/dev/null || die "It didn't push :1"