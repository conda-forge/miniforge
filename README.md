# miniforge
[![Build Status](https://travis-ci.org/conda-forge/miniforge.svg?branch=master)](https://travis-ci.org/conda-forge/miniforge)

This repository holds a minimal installer for conda on platforms that conda-forge supports but that aren't supported by Miniconda.

**Important:** This work is still very experimental.

Relevant conversations:

- https://github.com/conda-forge/conda-forge.github.io/issues/871#issue-496677528
- https://github.com/conda-forge/conda-forge.github.io/pull/922

Features of this repository to implement:

- [ ] Automatic build of constructor
  - [ ] aarch64 -- https://github.com/conda-forge/miniforge/pull/1
  - [ ] Other architectures???
- [ ] Automatic upload of constructor results
  - [ ] Test: https://github.com/conda-forge/miniforge/pull/1
- [ ] Automatic testing of constructor on Ubuntu 18.04 docker image
- [ ] Integration with conda-forge's developer documentation
- [ ] Integration with conda-forge's official site
- [ ] Upstream to Anaconda ???

## Usage

Installers are built and uploaded via Travis but if you want to construct your own Miniforge installer, here is how:

```bash
## Permission for Docker
chmod 777 build/
chmod 666 Miniforge3/construct.yaml

# Enable QEMU in Docker
docker run --rm --privileged multiarch/qemu-user-static:register --reset --credential yes

# Build the image
docker build -t forge_constructor -f Dockerfile.aarch64 .

# Construct the installer
docker run --rm -ti --mount type=bind,source="$(pwd)",target=/construct forge_constructor

# Test the installer
docker run --rm -ti --mount type=bind,source="$(pwd)",target=/construct forge_constructor /construct/test.sh
```
