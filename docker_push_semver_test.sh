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

OUTPUT=$(dockerPushSemver "test-1" "1.2.3-test")
cat <<<$OUTPUT
grep "push.*test-1:latest" <<<$OUTPUT >/dev/null || die "It didn't push test-1:latest"
grep "push.*test-1:1.2.3-test\$" <<<$OUTPUT >/dev/null || die "It didn't push test-1:1.2.3-test"
grep "push.*test-1:1.2.3\$" <<<$OUTPUT >/dev/null && die "It pushed test-1:1.2.3 with a SPECIAL"
grep "push.*test-1:1.2\$" <<<$OUTPUT >/dev/null && die "It pushed test-1:1.2 with a SPECIAL"
grep "push.*test-1:1\$" <<<$OUTPUT >/dev/null && die "It pushed test-1:1 with a SPECIAL"

OUTPUT=$(dockerPushSemver "test-2" "1.2.3")
cat <<<$OUTPUT
grep "push.*test-2:latest\$" <<<$OUTPUT >/dev/null || die "It didn't push test-2:latest"
grep "push.*test-2:1.2.3\$" <<<$OUTPUT >/dev/null || die "It didn't push test-2:1.2.3"
grep "push.*test-2:1.2\$" <<<$OUTPUT >/dev/null || die "It didn't push test-2:1.2"
grep "push.*test-2:1\$" <<<$OUTPUT >/dev/null || die "It didn't push test-2:1"