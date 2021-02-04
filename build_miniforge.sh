#!/usr/bin/env bash
# Build miniforge installers for Linux 
# on various architectures (aarch64, x86_64, ppc64le)
# Notes:
# It uses the qemu-user-static [1] emulator to enable 
# the use of containers images with different architectures than the host
# [1]: https://github.com/multiarch/qemu-user-static/
# See also: [setup-qemu-action](https://github.com/docker/setup-qemu-action)
set -ex

# Check parameters
ARCH=${ARCH:-aarch64}
DOCKER_ARCH=${DOCKER_ARCH:-arm64v8}
DOCKERIMAGE=${DOCKERIMAGE:-condaforge/linux-anvil-aarch64}
MINIFORGE_NAME=${MINIFORGE_NAME:-Miniforge3}
export CONSTRUCT_ROOT=/construct

echo "============= Create build directory ============="
mkdir -p build/
chmod 777 build/

echo "============= Enable QEMU ============="
# Enable qemu in persistent mode
docker run --rm --privileged multiarch/qemu-user-static \
  --reset --credential yes --persistent yes

echo "============= Build the installer ============="
docker run --rm -v "$(pwd):/construct" \
  -e CONSTRUCT_ROOT -e MINIFORGE_VERSION -e MINIFORGE_NAME \
  ${DOCKERIMAGE} /construct/scripts/build.sh

echo "============= Test the installer ============="
for TEST_IMAGE_NAME in "ubuntu:20.04" "ubuntu:19.10" "ubuntu:16.04" "ubuntu:18.04" "centos:7" "debian:buster"; do
  echo "============= Test installer on ${TEST_IMAGE_NAME} ============="
  docker run --rm -v "$(pwd):/construct" -e CONSTRUCT_ROOT \
    "${DOCKER_ARCH}/${TEST_IMAGE_NAME}" /construct/scripts/test.sh
done

echo "============= Build the docker container ============="
MINIFORGE_FILE=$(ls build/${MINIFORGE_NAME}-*-Linux-${ARCH}.sh)
MINIFORGE_FILE=(${MINIFORGE_FILE//-/ })
MINIFORGE_VERSION=${MINIFORGE_FILE[1]}-${MINIFORGE_FILE[2]}
MINIFORGE_IMAGE=condaforge/${MINIFORGE_NAME/M/m}
docker build -t ${MINIFORGE_IMAGE} --build-arg MINIFORGE_VERSION=${MINIFORGE_VERSION} --build-arg ARCH=${ARCH} --build-arg MINIFORGE_NAME=${MINIFORGE_NAME} -f docker/Dockerfile --no-cache --squash .
docker tag ${MINIFORGE_IMAGE}:latest ${MINIFORGE_IMAGE}:${MINIFORGE_VERSION}

echo "============= Test the docker container ============="
docker build -f docker/tests/Dockerfile.root --build-arg IMAGE_TO_TEST=${MINIFORGE_IMAGE} docker/tests
docker build -f docker/tests/Dockerfile.non-root --build-arg IMAGE_TO_TEST=${MINIFORGE_IMAGE} docker/tests
