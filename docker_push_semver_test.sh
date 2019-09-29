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
grep "t.*st" <<<$TEST || die "here-string doesn't work in this bash"

dockerPushSemver "test-1" "1.2.3-test" | grep "push.*test-1:latest\$" >/dev/null || die "It didn't push test-1:latest"
dockerPushSemver "test-1" "1.2.3-test" | grep "push.*test-1:1.2.3-test\$" >/dev/null || die "It didn't push test-1:1.2.3-test"
dockerPushSemver "test-1" "1.2.3-test" | grep "push.*test-1:1.2.3\$" >/dev/null && die "It pushed test-1:1.2.3 with a SPECIAL"
dockerPushSemver "test-1" "1.2.3-test" | grep "push.*test-1:1.2\$" >/dev/null && die "It pushed test-1:1.2 with a SPECIAL"
dockerPushSemver "test-1" "1.2.3-test" | grep "push.*test-1:1\$" >/dev/null && die "It pushed test-1:1 with a SPECIAL"

dockerPushSemver "test-2" "1.2.3" | grep "push.*test-2:latest\$" >/dev/null || die "It didn't push test-2:latest"
dockerPushSemver "test-2" "1.2.3" | grep "push.*test-2:1.2.3\$" >/dev/null || die "It didn't push test-2:1.2.3"
dockerPushSemver "test-2" "1.2.3" | grep "push.*test-2:1.2\$" >/dev/null || die "It didn't push test-2:1.2"
dockerPushSemver "test-2" "1.2.3" | grep "push.*test-2:1\$" >/dev/null || die "It didn't push test-2:1"