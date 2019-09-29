<img src="https://img.shields.io/travis/misterjoshua/docker-push-semver-bash" alt="Build Status">

# Docker Push Semver (For Bash)
This is a bash-based script to push semver-tagged docker images. After building `myuser/myrepo:latest` locally, given a version number, this script will push `myuser/myrepo:latest` and `myuser/myrepo:$VERSION`. If the version string is a plain semver version such as `3.2.1` (not `3.2.1-prerelease`) the script will also push these tags: `$MAJOR.$MINOR`, and `$MAJOR`.

## Usage
docker_push_semver can be used from the command line as:

```
$ docker build -t myrepo/myrepo:latest .
$ echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
$ ./docker_push_semver.sh "myrepo/myrepo" "3.2.1"
latest: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3.2.1: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3.2: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
```

Alternatively, you can source it from within a script:

```
$ docker build -t myrepo/myrepo:latest .
$ echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
source <(curl -s https://raw.githubusercontent.com/misterjoshua/docker-push-semver-bash/master/docker_push_semver.sh)
$ dockerPushSemver "myrepo/myrepo" "3.2.1"
latest: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3.2.1: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3.2: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
```

Or, you can use it in your build to simplify the build script, such as in travis ci:

```
language: generic
services:
- docker

script:
- set -e
- docker build -t $DOCKER_REPO:latest .
- source <(curl -s https://raw.githubusercontent.com/misterjoshua/docker-push-semver-bash/master/docker_push_semver.sh)
- echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
- dockerPushSemver $DOCKER_REPO `git describe --tags`
```