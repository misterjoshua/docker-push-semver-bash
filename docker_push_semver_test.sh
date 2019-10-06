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

# Test the "don't push local build tag" option
dockerPushSemver -d "test-dont-push-local" "1.2.3" | grep "push.*test-dont-push-local:latest\$" >/dev/null && die "It pushed test-semver:latest when it shouldn't have"

# Test plain semvers with a latest tag other than "latest" - we want to see these tags pushed: 'newest', '1.2.3', '1.2', and '1'
dockerPushSemver -b "newest" "test-othertag" "1.2.3" | grep "push.*test-othertag:newest\$" >/dev/null || die "It didn't push test-othertag:newest"
dockerPushSemver -b "newest" "test-othertag" "1.2.3" | grep "push.*test-othertag:1.2.3\$" >/dev/null || die "It didn't push test-othertag:1.2.3"
dockerPushSemver -b "newest" "test-othertag" "1.2.3" | grep "push.*test-othertag:1.2\$" >/dev/null || die "It didn't push test-othertag:1.2"
dockerPushSemver -b "newest" "test-othertag" "1.2.3" | grep "push.*test-othertag:1\$" >/dev/null || die "It didn't push test-othertag:1"

# Test 'special' versions - we don't want to push the version tags, but we do want to push latest
dockerPushSemver "test-semver-special" "1.2.3-test" | grep "push.*test-semver-special:latest\$" >/dev/null || die "It didn't push test-semver-special:latest"
dockerPushSemver "test-semver-special" "1.2.3-test" | grep "push.*test-semver-special:1.2.3-test\$" >/dev/null || die "It didn't push test-semver-special:1.2.3-test"
dockerPushSemver "test-semver-special" "1.2.3-test" | grep "push.*test-semver-special:1.2.3\$" >/dev/null && die "It pushed test-semver-special:1.2.3 with a SPECIAL"
dockerPushSemver "test-semver-special" "1.2.3-test" | grep "push.*test-semver-special:1.2\$" >/dev/null && die "It pushed test-semver-special:1.2 with a SPECIAL"
dockerPushSemver "test-semver-special" "1.2.3-test" | grep "push.*test-semver-special:1\$" >/dev/null && die "It pushed test-semver-special:1 with a SPECIAL"

# Test variations on "latest"
dockerPushSemver -v "-alpine" "test-variations" "1.2.3" | grep "push.*test-variations:latest\$" >/dev/null || die "It didn't push test-variations:latest"
dockerPushSemver -v "-alpine" "test-variations" "1.2.3" | grep "push.*test-variations:1.2.3-alpine\$" >/dev/null || die "It didn't push test-variations:1.2.3-alpine"
dockerPushSemver -v "-alpine" "test-variations" "1.2.3" | grep "push.*test-variations:1.2-alpine\$" >/dev/null || die "It didn't push test-variations:1.2-alpine"
dockerPushSemver -v "-alpine" "test-variations" "1.2.3" | grep "push.*test-variations:1-alpine\$" >/dev/null || die "It didn't push test-variations:1-alpine"

# Test variations with a specific latest tag
dockerPushSemver -b "latest-alpine" -v "-alpine" "test-variation-othertag" "1.2.3" | grep "push.*test-variation-othertag:latest-alpine\$" >/dev/null || die "It didn't push test-variation-othertag:latest-alpine"
dockerPushSemver -b "latest-alpine" -v "-alpine" "test-variation-othertag" "1.2.3" | grep "push.*test-variation-othertag:1.2.3-alpine\$" >/dev/null || die "It didn't push test-variation-othertag:1.2.3-alpine"
dockerPushSemver -b "latest-alpine" -v "-alpine" "test-variation-othertag" "1.2.3" | grep "push.*test-variation-othertag:1.2-alpine\$" >/dev/null || die "It didn't push test-variation-othertag:1.2-alpine"
dockerPushSemver -b "latest-alpine" -v "-alpine" "test-variation-othertag" "1.2.3" | grep "push.*test-variation-othertag:1-alpine\$" >/dev/null || die "It didn't push test-variation-othertag:1-alpine"

# Success!
echo "Tests succeeded"