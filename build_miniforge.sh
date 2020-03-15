#!/usr/bin/env bash

set -e

# Check parameters
ARCH=${ARCH:-aarch64}
DOCKER_ARCH=${DOCKER_ARCH:arm64v8}
DOCKERIMAGE=${DOCKERIMAGE:-condaforge/linux-anvil-aarch64}

echo "============= Create build directory ============="
mkdir -p build/
chmod 777 build/

echo "============= Enable QEMU ============="
docker run --rm --privileged multiarch/qemu-user-static:register --reset --credential yes

echo "============= Build the installer ============="
docker run --rm -ti -v $(pwd):/construct -e MINIFORGE_VERSION -e MINIFORGE_NAME $DOCKERIMAGE /construct/scripts/build.sh

echo "============= Download QEMU static binaries ============="
bash scripts/get_qemu.sh

echo "============= Test the installer ============="
for TEST_IMAGE_NAME in "ubuntu:19.10" "ubuntu:16.04" "ubuntu:18.04" "centos:7" "debian:buster"
do
  echo "============= Test installer on $TEST_IMAGE_NAME ============="
  docker run --rm -ti -v $(pwd):/construct -v $(pwd)/build/qemu/qemu-${ARCH}-static:/usr/bin/qemu-${ARCH}-static ${DOCKER_ARCH}/$TEST_IMAGE_NAME /construct/scripts/test.sh
done

