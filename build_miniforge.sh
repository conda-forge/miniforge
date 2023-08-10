#!/usr/bin/env bash
# Build miniforge installers for Linux
# on various architectures (aarch64, x86_64, ppc64le)
# Notes:
# It uses the qemu emulator (see [1] or [2]) to enable
# the use of containers images with different architectures than the host
# [1]: https://github.com/multiarch/qemu-user-static/
# [2]: https://github.com/tonistiigi/binfmt
# See also: [setup-qemu-action](https://github.com/docker/setup-qemu-action)
set -ex

# Check parameters
ARCH=${ARCH:-aarch64}
export TARGET_PLATFORM=${TARGET_PLATFORM:-linux-aarch64}
DOCKER_ARCH=${DOCKER_ARCH:-arm64v8}
DOCKERIMAGE=${DOCKERIMAGE:-condaforge/linux-anvil-aarch64}
export MINIFORGE_NAME=${MINIFORGE_NAME:-Miniforge3}
OS_NAME=${OS_NAME:-Linux}
EXT=${EXT:-sh}
TEST_IMAGE_NAMES=${TEST_IMAGE_NAMES:-ubuntu:22.04 ubuntu:20.04 ubuntu:18.04 ubuntu:16.04 centos:7 debian:bullseye debian:buster}
export CONSTRUCT_ROOT=/construct

echo "============= Create build directory ============="
mkdir -p build/
chmod 777 build/

echo "============= Enable QEMU ============="
# Enable qemu in persistent mode
docker run --privileged --rm tonistiigi/binfmt --install all

echo "============= Build the installer ============="
docker run --rm -v "$(pwd):/construct" \
  -e CONSTRUCT_ROOT -e MINIFORGE_VERSION -e MINIFORGE_NAME -e TARGET_PLATFORM \
  "${DOCKERIMAGE}" /construct/scripts/build.sh

echo "============= Test the installer ============="
for TEST_IMAGE_NAME in ${TEST_IMAGE_NAMES}; do
  echo "============= Test installer on ${TEST_IMAGE_NAME} ============="
  docker run --rm \
    -v "$(pwd):${CONSTRUCT_ROOT}" -e CONSTRUCT_ROOT \
    "${DOCKER_ARCH}/${TEST_IMAGE_NAME}" /construct/scripts/test.sh
done
