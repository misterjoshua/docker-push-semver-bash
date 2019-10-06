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

# Test plain semvers - we want to see these tags pushed: 'latest', '1.2.3', '1.2', and '1'
dockerPushSemver "test-semver" "1.2.3" | grep "push.*test-semver:latest\$" >/dev/null || die "It didn't push test-semver:latest"
dockerPushSemver "test-semver" "1.2.3" | grep "push.*test-semver:1.2.3\$" >/dev/null || die "It didn't push test-semver:1.2.3"
dockerPushSemver "test-semver" "1.2.3" | grep "push.*test-semver:1.2\$" >/dev/null || die "It didn't push test-semver:1.2"
dockerPushSemver "test-semver" "1.2.3" | grep "push.*test-semver:1\$" >/dev/null || die "It didn't push test-semver:1"

# Test plain semvers with a latest tag other than "latest" - we want to see these tags pushed: 'newest', '1.2.3', '1.2', and '1'
dockerPushSemver "test-othertag" "1.2.3" "newest" | grep "push.*test-othertag:newest\$" >/dev/null || die "It didn't push test-othertag:newest"
dockerPushSemver "test-othertag" "1.2.3" "newest" | grep "push.*test-othertag:1.2.3\$" >/dev/null || die "It didn't push test-othertag:1.2.3"
dockerPushSemver "test-othertag" "1.2.3" "newest" | grep "push.*test-othertag:1.2\$" >/dev/null || die "It didn't push test-othertag:1.2"
dockerPushSemver "test-othertag" "1.2.3" "newest" | grep "push.*test-othertag:1\$" >/dev/null || die "It didn't push test-othertag:1"

# Test 'special' versions - we don't want to push the version tags, but we do want to push latest
dockerPushSemver "test-semver-special" "1.2.3-test" | grep "push.*test-semver-special:latest\$" >/dev/null || die "It didn't push test-semver-special:latest"
dockerPushSemver "test-semver-special" "1.2.3-test" | grep "push.*test-semver-special:1.2.3-test\$" >/dev/null || die "It didn't push test-semver-special:1.2.3-test"
dockerPushSemver "test-semver-special" "1.2.3-test" | grep "push.*test-semver-special:1.2.3\$" >/dev/null && die "It pushed test-semver-special:1.2.3 with a SPECIAL"
dockerPushSemver "test-semver-special" "1.2.3-test" | grep "push.*test-semver-special:1.2\$" >/dev/null && die "It pushed test-semver-special:1.2 with a SPECIAL"
dockerPushSemver "test-semver-special" "1.2.3-test" | grep "push.*test-semver-special:1\$" >/dev/null && die "It pushed test-semver-special:1 with a SPECIAL"

# Test variations on "latest"
dockerPushSemver "test-3" "1.2.3" "" "-alpine" | grep "push.*test-3:latest\$" >/dev/null || die "It didn't push test-3:latest"
dockerPushSemver "test-3" "1.2.3" "" "-alpine" | grep "push.*test-3:1.2.3-alpine\$" >/dev/null || die "It didn't push test-3:1.2.3-alpine"
dockerPushSemver "test-3" "1.2.3" "" "-alpine" | grep "push.*test-3:1.2-alpine\$" >/dev/null || die "It didn't push test-3:1.2-alpine"
dockerPushSemver "test-3" "1.2.3" "" "-alpine" | grep "push.*test-3:1-alpine\$" >/dev/null || die "It didn't push test-3:1-alpine"

# Test variations with a specific latest tag
dockerPushSemver "test-3" "1.2.3" "latest-alpine" "-alpine" | grep "push.*test-3:latest-alpine\$" >/dev/null || die "It didn't push test-3:latest-alpine"
dockerPushSemver "test-3" "1.2.3" "latest-alpine" "-alpine" | grep "push.*test-3:1.2.3-alpine\$" >/dev/null || die "It didn't push test-3:1.2.3-alpine"
dockerPushSemver "test-3" "1.2.3" "latest-alpine" "-alpine" | grep "push.*test-3:1.2-alpine\$" >/dev/null || die "It didn't push test-3:1.2-alpine"
dockerPushSemver "test-3" "1.2.3" "latest-alpine" "-alpine" | grep "push.*test-3:1-alpine\$" >/dev/null || die "It didn't push test-3:1-alpine"
echo "Tests succeeded"