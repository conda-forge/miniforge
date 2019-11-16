# miniforge
[![Build Status](https://travis-ci.org/conda-forge/miniforge.svg?branch=master)](https://travis-ci.org/conda-forge/miniforge)

This repository holds a minimal installer for conda on platforms that conda-forge supports but that aren't supported by [Miniconda]((https://docs.conda.io/en/latest/miniconda.html).

**Important: This work is still very experimental.**

Relevant conversations:

- https://github.com/conda-forge/conda-forge.github.io/issues/871#issue-496677528
- https://github.com/conda-forge/conda-forge.github.io/pull/922

## Download

Miniforge installers are available here: https://github.com/conda-forge/miniforge/releases.

## Supported architectures

- `aarch64` (also called `arm64`)

## Features

- [X] Automatic build of constructor.
- [X] Automatic upload of constructor results.
- [X] Automatic testing of constructor.
- [ ] Integration with conda-forge's developer documentation.
- [ ] Integration with conda-forge's official site.
- [ ] Upstream to Anaconda ?

## Testing

After construction on Travis, the installer is tested against a range of distribution that match the installer architecture (`$ARCH`). For example when architecture is `aarch64`, the constructed installer is tested against:

- Centos 7
- Ubuntu 16.04
- Ubuntu 18.04
- Ubuntu 19.10

## Usage

Installers are built and uploaded via Travis but if you want to construct your own Miniforge installer, here is how:

```bash
# Configuration
export ARCH=aarch64
export DOCKERIMAGE=condaforge/linux-anvil-aarch64
export QEMU_BINARY=qemu-aarch64-static

# Permission for Docker
chmod 777 build/

# Enable QEMU in Docker
docker run --rm --privileged multiarch/qemu-user-static:register --reset --credential yes

# Construct the installer
docker run --rm -ti -v $(pwd):/construct $DOCKERIMAGE /construct/build.sh

# Test the installer
bash get_qemu.sh

for DOCKERFILE_PATH in $(find test_images/ -name "*.$ARCH")
do
  TEST_IMAGE_SUFFIX=$(echo $DOCKERFILE_PATH  | cut -d'.' -f2-)
  TEST_IMAGE_NAME="miniforge_test_image.$TEST_IMAGE_SUFFIX"

  echo "============= Building $TEST_IMAGE_NAME ============="
  docker build -t $TEST_IMAGE_NAME -f $DOCKERFILE_PATH .

  echo "============= Test installer on $TEST_IMAGE_NAME ============="
  docker run --rm -ti -v $(pwd):/construct $TEST_IMAGE_NAME /construct/test.sh
done
```

## License

[BDS 3-clause](./LICENSE)
