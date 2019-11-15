# miniforge
[![Build Status](https://travis-ci.org/conda-forge/miniforge.svg?branch=master)](https://travis-ci.org/conda-forge/miniforge)

This repository holds a minimal installer for conda on platforms that conda-forge supports but that aren't supported by Miniconda.

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

## Usage

Installers are built and uploaded via Travis but if you want to construct your own Miniforge installer, here is how:

```bash
# Enable QEMU in Docker
docker run --rm --privileged multiarch/qemu-user-static:register --reset --credential yes

# Construct the installer
docker run --rm -ti --mount type=bind,source="$(pwd)",target=/construct condaforge/linux-anvil-aarch64 /construct/build.sh

# Test the installer
docker run --rm -ti --mount type=bind,source="$(pwd)",target=/construct condaforge/linux-anvil-aarch64 /construct/test.sh
```

## License

[BDS 3-clause](./LICENSE)
