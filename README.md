# Miniforge
![Build Miniforge](https://github.com/conda-forge/miniforge/workflows/Build%20miniforge/badge.svg)

This repository holds a minimal installer for [Conda](https://conda.io/) specific to [conda-forge](https://conda-forge.org/). It is comparable to [Miniconda](https://docs.conda.io/en/latest/miniconda.html), but with:

* `conda-forge` set as the default channel
* an emphasis on supporting various CPU architectures
* optional support for [PyPy](https://www.pypy.org/) in place of standard Python (aka "CPython")
* optional support for [Mamba](https://github.com/mamba-org/mamba) in place of Conda

## Download

Miniforge installers are available here: https://github.com/conda-forge/miniforge/releases

#### Miniforge3

Latest installers with Python 3.8 `(*)` in the base environment:

| OS      | Architecture          | Download  |
| --------|-----------------------|-----------|
| Linux   | x86_64 (amd64)        | [Miniforge3-Linux-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh) |
| Linux   | aarch64 (arm64)       | [Miniforge3-Linux-aarch64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh) |
| Linux   | ppc64le (POWER8/9)    | [Miniforge3-Linux-ppc64le](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-ppc64le.sh) |
| OS X    | x86_64                | [Miniforge3-MacOSX-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh) |
| OS X    | arm64 (Apple Silicon) `(**)` | [Miniforge3-MacOSX-arm64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh) |
| Windows | x86_64                | [Miniforge3-Windows-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe) |

`(*)` OS X `arm64` will be installed with Python 3.9.
The Python version is specific only to the base environment. Conda can create new environments with different Python versions and implementations.

`(**)` Apple silicon builds are experimental and haven't had testing like the other platforms.

#### Miniforge-pypy3

Latest installers with PyPy 3.6 in the base environment:

| OS      | Architecture          | Download  |
| --------|-----------------------|-----------|
| Linux   | x86_64 (amd64)        | [Miniforge-pypy3-Linux-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Linux-x86_64.sh) |
| Linux   | aarch64 (arm64)       | [Miniforge-pypy3-Linux-aarch64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Linux-aarch64.sh) |
| Linux   | ppc64le (POWER8/9)    | [Miniforge-pypy3-Linux-ppc64le](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Linux-ppc64le.sh) |
| OS X    | x86_64                | [Miniforge-pypy3-MacOSX-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-MacOSX-x86_64.sh) |

#### Mambaforge

Latest installers with Mamba in the base environment:


| OS      | Architecture          | Download  |
| --------|-----------------------|-----------|
| Linux   | x86_64 (amd64)        | [Mambaforge-Linux-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh) |
| Linux   | aarch64 (arm64)       | [Mambaforge-Linux-aarch64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-aarch64.sh) |
| Linux   | ppc64le (POWER8/9)    | [Mambaforge-Linux-ppc64le](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-ppc64le.sh) |
| OS X    | x86_64                | [Mambaforge-MacOSX-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-MacOSX-x86_64.sh) |
| OS X    | arm64 (Apple Silicon) | [Mambaforge-MacOSX-arm64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-MacOSX-arm64.sh) |
| Windows | x86_64                | [Mambaforge-Windows-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Windows-x86_64.exe) |

#### Mambaforge-pypy3

Latest installers with Mamba and PyPy 3.6 in the base environment:

| OS      | Architecture          | Download  |
| --------|-----------------------|-----------|
| Linux   | x86_64 (amd64)        | [Mambaforge-pypy3-Linux-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-Linux-x86_64.sh) |
| Linux   | aarch64 (arm64)       | [Mambaforge-pypy3-Linux-aarch64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-Linux-aarch64.sh) |
| Linux   | ppc64le (POWER8/9)    | [Mambaforge-pypy3-Linux-ppc64le](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-Linux-ppc64le.sh) |
| OS X    | x86_64                | [Mambaforge-pypy3-MacOSX-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-MacOSX-x86_64.sh) |

## Install

To install download the installer and run,

    bash Miniforge3-Linux-x86_64.sh   # or similar for other installers for unix platforms

or if you are on Windows, double click on the installer.

### Non-interactive install

For non-interactive usage, look at the options by running the following:

    bash Miniforge3-Linux-x86_64.sh -h   # or similar for other installers for unix platforms

or if you are on windows, run:

    start /wait "" build/Miniforge3-Windows-x86_64.exe /InstallationType=JustMe /RegisterPython=0 /S /D=%UserProfile%\Miniforge3

### Downloading the installer as part of a CI pipeline

If you wish to download the appropriate installer through the command line in a
more automated fashion, you may wish to a command similar to

For Linux, any architecture, use the following command

    wget -O Miniforge3.sh https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh

For MacOSX, any architecture, use the following command

    curl -fsSLo Miniforge3.sh https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh

This will download the appropriate installer for the present architecture with
the filename ``Miniforge3.sh``. Run the shell script with the command in batch
mode with the `-b` flash:

    bash Miniforge3.sh -b

### Homebrew

On macOS, you can install miniforge with [Homebrew](https://brew.sh/) by running

    brew install miniforge

## Features

- [X] Automatic build of constructor.
- [X] Automatic upload of constructor results.
- [X] Automatic testing of constructor.
- [ ] Integration with conda-forge's developer documentation.
- [ ] Integration with conda-forge's official site.
- [ ] Upstream to Anaconda ?

## Testing

After construction on the CI, the installer is tested against a range of distribution that match the installer architecture (`$ARCH`). For example when architecture is `aarch64`, the constructed installer is tested against:

- Centos 7
- Debian Buster (10)
- Ubuntu 16.04
- Ubuntu 18.04
- Ubuntu 19.10
- Ubuntu 20.04

## Usage

Installers are built and uploaded via the CI but if you want to construct your own Miniforge installer, here is how:

```bash
# Configuration
export ARCH=aarch64
export DOCKERIMAGE=condaforge/linux-anvil-aarch64

bash build_miniforge.sh
```

## Release

To release a new version of Miniforge:

- Make a new pre-release on GitHub with name `$CONDA_VERSION-$BUILD_NUMBER`
- Wait until all artifacts are uploaded by CI
  - For each build, we upload 3 artifacts
    1. One installer with the version name
    2. One installer without the version name
    3. The SHA256
  - At the time of writing, the is a sum of 60 artifacts, and with the two sources, we expect a grand total of 62 artifacts.
- Mark the pre-release as a release

NOTE: using a pre-release is important to make sure the latest links work.

## License

[BSD 3-Clause](./LICENSE)

## History

Relevant conversations:

- https://github.com/conda-forge/conda-forge.github.io/issues/871#issue-496677528
- https://github.com/conda-forge/conda-forge.github.io/pull/922
