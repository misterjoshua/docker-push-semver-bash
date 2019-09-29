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

TEST="test"
grep "test" <<<$TEST || die "here-string doesn't work in this bash"

DOCKER_REPO="test-1"
OUTPUT=$(dockerPushSemver "$DOCKER_REPO" "1.2.3-test")
grep "push.*$DOCKER_REPO:latest$" <<<$OUTPUT >/dev/null || die "It didn't push $DOCKER_REPO:latest"
grep "push.*$DOCKER_REPO:1.2.3-test$" <<<$OUTPUT >/dev/null || die "It didn't push $DOCKER_REPO:1.2.3-test"
grep "push.*$DOCKER_REPO:1.2.3$" <<<$OUTPUT >/dev/null && die "It pushed $DOCKER_REPO:1.2.3 with a SPECIAL"
grep "push.*$DOCKER_REPO:1.2$" <<<$OUTPUT >/dev/null && die "It pushed $DOCKER_REPO:1.2 with a SPECIAL"
grep "push.*$DOCKER_REPO:1$" <<<$OUTPUT >/dev/null && die "It pushed $DOCKER_REPO:1 with a SPECIAL"

DOCKER_REPO="test-2"
OUTPUT=$(dockerPushSemver "$DOCKER_REPO" "1.2.3")
grep "push.*$DOCKER_REPO:latest$" <<<$OUTPUT >/dev/null || die "It didn't push $DOCKER_REPO:latest"
grep "push.*$DOCKER_REPO:1.2.3$" <<<$OUTPUT >/dev/null || die "It didn't push $DOCKER_REPO:1.2.3"
grep "push.*$DOCKER_REPO:1.2$" <<<$OUTPUT >/dev/null || die "It didn't push $DOCKER_REPO:1.2"
grep "push.*$DOCKER_REPO:1$" <<<$OUTPUT >/dev/null || die "It didn't push $DOCKER_REPO:1"