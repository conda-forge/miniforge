#!/usr/bin/env bash

set -e

# Check parameters
ARCH=${ARCH:-aarch64}
DOCKERIMAGE=${DOCKERIMAGE:-condaforge/linux-anvil-aarch64}
QEMU_BINARY=${QEMU_BINARY:-qemu-aarch64-static}

echo "============= Create build directory ============="
mkdir -p build/
chmod 777 build/

echo "============= Enable QEMU ============="
docker run --rm multiarch/qemu-user-static:register --reset --credential yes

echo "============= Build the installer ============="
docker run --rm -ti -v $(pwd):/construct $DOCKERIMAGE /construct/scripts/build.sh

echo "============= Download QEMU static binaries ============="
bash scripts/get_qemu.sh

echo "============= Test the installer ============="
for DOCKERFILE_PATH in $(find test_images/ -name "*.$ARCH")
do
  TEST_IMAGE_SUFFIX=$(echo $DOCKERFILE_PATH  | cut -d'.' -f2-)
  TEST_IMAGE_NAME="miniforge_test_image.$TEST_IMAGE_SUFFIX"

  echo "============= Building $TEST_IMAGE_NAME ============="
  docker build -t $TEST_IMAGE_NAME -f $DOCKERFILE_PATH .

  echo "============= Test installer on $TEST_IMAGE_NAME ============="
  docker run --rm -ti -v $(pwd):/construct $TEST_IMAGE_NAME /construct/scripts/test.sh
done

