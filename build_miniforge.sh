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

BUILD_ARCH=$(uname -m)
# Check parameters
ARCH=${ARCH:-${BUILD_ARCH}}
if [[ "${BUILD_ARCH}" == "x86_64" ]]; then
    export TARGET_PLATFORM=${TARGET_PLATFORM:-linux-64}
else
    export TARGET_PLATFORM=${TARGET_PLATFORM:-linux-${BUILD_ARCH}}
fi
if [[ "${BUILD_ARCH}" == "aarch64" ]]; then
    DOCKER_ARCH=${DOCKER_ARCH:-arm64v8}
elif [[ "${BUILD_ARCH}" == "x86_64" ]]; then
    DOCKER_ARCH=${DOCKER_ARCH:-amd64}
else
    DOCKER_ARCH=${DOCKER_ARCH:-${BUILD_ARCH}}
fi

if [[ "${BUILD_ARCH}" == "x86_64" ]]; then
    DOCKERIMAGE=${DOCKERIMAGE:-condaforge/linux-anvil-comp7}
else
    DOCKERIMAGE=${DOCKERIMAGE:-condaforge/linux-anvil-${BUILD_ARCH}}
fi

export MINIFORGE_NAME=${MINIFORGE_NAME:-Miniforge3}
OS_NAME=${OS_NAME:-Linux}
EXT=${EXT:-sh}
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

# copy the installer for latest
cp "build/${MINIFORGE_NAME}-"*"-${OS_NAME}-${ARCH}.${EXT}" "build/${MINIFORGE_NAME}-${OS_NAME}-${ARCH}.${EXT}"

echo "============= Test the installer ============="
for TEST_IMAGE_NAME in "ubuntu:21.10" "ubuntu:20.04" "ubuntu:18.04" "ubuntu:16.04" "centos:7" "debian:bullseye" "debian:buster"; do
  echo "============= Test installer on ${TEST_IMAGE_NAME} ============="
  docker run --rm -v "$(pwd):/construct" -e CONSTRUCT_ROOT \
    "${DOCKER_ARCH}/${TEST_IMAGE_NAME}" /construct/scripts/test.sh
done
