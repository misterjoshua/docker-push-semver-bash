<img src="https://img.shields.io/travis/misterjoshua/docker-push-semver-bash" alt="Build Status">

# Docker Push Semver (For Bash)
This bash script tags and pushes Docker images for major and minor versions of a locally-built docker image. An image tagged with the given version string will always be pushed, but the major and minor tags will only be pushed if the version string does not include pre-release or build version suffixes. (e.g., major/minor tags will be pushed for `3.2.1` but not `3.2.1-somethinghere`.)

To use this script, download it locally or source it from your build script. An example of sourcing the script from curl is preovided below.

## Usage
```
usage: docker_push_semver.sh [-d] [-b <tag>] [-v <variation>] <docker_repo> <semantic_version>
  Tag and push docker images for major and minor versions of a locally built
  image if the version number provided doesn't include a pre-release tag.

  Options:
    -b tag        Specify a local tag to use rather than 'latest'
    -d            Don't push the local tag
    -h            Show help
    -v variation  Append a variation suffix to the tagged images
```

## Examples
### Local download

```
$ docker build -t myrepo/myrepo:latest .
$ echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
$ ./docker_push_semver.sh "myrepo/myrepo" "3.2.1"
latest: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3.2.1: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3.2: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
```

### Sourced

```
$ docker build -t myrepo/myrepo:latest .
$ echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
$ source <(curl -s https://raw.githubusercontent.com/misterjoshua/docker-push-semver-bash/master/docker_push_semver.sh)
$ dockerPushSemver "myrepo/myrepo" "3.2.1"
latest: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3.2.1: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3.2: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
3: digest: sha256:112d23845010ef8b50954f593bcdebddbc47483c2dfa471ac5f753b12a2d0817 size: 734
```

### Travis CI Snippet
You can use this script in your build to simplify the build script:

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