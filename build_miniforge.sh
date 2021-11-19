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
FORGE_INSTALLER_LATEST="${MINIFORGE_NAME}-${OS_NAME}-${ARCH}.${EXT}"
export INSTALLER_PATH="build/${FORGE_INSTALLER_LATEST}"
cp "build/${MINIFORGE_NAME}-"*"-${OS_NAME}-${ARCH}.${EXT}" "${INSTALLER_PATH}"


echo "============= Test the installer ============="
for TEST_IMAGE_NAME in "opensuse/tumbleweed" "ubuntu:21.04" "ubuntu:20.04" "ubuntu:18.04" "ubuntu:16.04" "centos:7" "debian:bullseye" "debian:buster"; do
  echo "============= Test installer on ${TEST_IMAGE_NAME} ============="
  DOCKER_PLATFORM="${DOCKER_ARCH}"
  if [[ "${TEST_IMAGE_NAME}" == "opensuse/tumbleweed" ]] && [[ "${DOCKER_ARCH}" == "arm64v8" ]]; then
    # OpenSUSE has slightly different naming conventions
    DOCKER_PLATFORM=aarch64
  fi
  docker run --platform=${DOCKER_PLATFORM} \
      --rm -v "$(pwd):/construct" \
      -e INSTALLER_PATH -e CONSTRUCT_ROOT \
    "${TEST_IMAGE_NAME}" /construct/scripts/test.sh
done
