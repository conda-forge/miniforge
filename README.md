# Miniforge
[![Build miniforge](https://github.com/conda-forge/miniforge/actions/workflows/ci.yml/badge.svg)](https://github.com/conda-forge/miniforge/actions/workflows/ci.yml)
[![GitHub downloads](https://img.shields.io/github/downloads/conda-forge/miniforge/total.svg)](https://tooomm.github.io/github-release-stats/?username=conda-forge&repository=miniforge)

This repository holds a minimal installer for [Conda](https://conda.io/) specific to [conda-forge](https://conda-forge.org/).
Miniforge allows you to install the conda package manager with the following features pre-configured:

* [conda-forge](https://conda-forge.org/) set as the default (and only) channel.
    * Packages in the base environment are obtained from the [conda-forge channel](https://anaconda.org/conda-forge).
* Optional support for PyPy in place of standard Python interpreter (aka "CPython").
* Optional support for [Mamba](https://github.com/mamba-org/mamba) in place of Conda.
* An emphasis on supporting various CPU architectures (x86_64, ppc64le, and aarch64 including Apple M1).

It can be compared to the [Miniconda](https://docs.conda.io/en/latest/miniconda.html) installer.

## Download

Miniforge installers are available here: https://github.com/conda-forge/miniforge/releases

#### Miniforge3

Latest installers with Python 3.10 `(*)` in the base environment:

| OS      | Architecture          | Download  |
| --------|-----------------------|-----------|
| Linux   | x86_64 (amd64)        | [Miniforge3-Linux-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh) |
| Linux   | aarch64 (arm64) `(**)` | [Miniforge3-Linux-aarch64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh) |
| Linux   | ppc64le (POWER8/9)    | [Miniforge3-Linux-ppc64le](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-ppc64le.sh) |
| OS X    | x86_64                | [Miniforge3-MacOSX-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh) |
| OS X    | arm64 (Apple Silicon) `(***)` | [Miniforge3-MacOSX-arm64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh) |
| Windows | x86_64                | [Miniforge3-Windows-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe) |

`(*)` The Python version is specific only to the base environment. Conda can create new environments with different Python versions and implementations.

`(**)` For Raspberry PI that include a 64 bit processor, you must also use 
a 64-bit operating system such as 
[Raspberry Pi OS 64-bit](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit) 
or 
[Ubuntu for Raspberry PI](https://ubuntu.com/raspberry-pi). 
The versions listed as "System: 32-bit" are not compatible with the installers on this website.

`(***)` Apple silicon builds are experimental and haven't had testing like the other platforms.

#### Miniforge-pypy3

Latest installers with PyPy 3.9 in the base environment:

| OS      | Architecture          | Download  |
| --------|-----------------------|-----------|
| Linux   | x86_64 (amd64)        | [Miniforge-pypy3-Linux-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Linux-x86_64.sh) |
| Linux   | aarch64 (arm64)       | [Miniforge-pypy3-Linux-aarch64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Linux-aarch64.sh) |
| Linux   | ppc64le (POWER8/9)    | [Miniforge-pypy3-Linux-ppc64le](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Linux-ppc64le.sh) |
| OS X    | x86_64                | [Miniforge-pypy3-MacOSX-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-MacOSX-x86_64.sh) |
| Windows | x86_64                | [Miniforge-pypy3-Windows-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Windows-x86_64.exe) |

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

Latest installers with Mamba and PyPy in the base environment:

| OS      | Architecture          | Download  |
| --------|-----------------------|-----------|
| Linux   | x86_64 (amd64)        | [Mambaforge-pypy3-Linux-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-Linux-x86_64.sh) |
| Linux   | aarch64 (arm64)       | [Mambaforge-pypy3-Linux-aarch64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-Linux-aarch64.sh) |
| Linux   | ppc64le (POWER8/9)    | [Mambaforge-pypy3-Linux-ppc64le](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-Linux-ppc64le.sh) |
| OS X    | x86_64                | [Mambaforge-pypy3-MacOSX-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-MacOSX-x86_64.sh) |
| Windows | x86_64                | [Mambaforge-pypy3-Windows-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-Windows-x86_64.exe) |

## Install

### Unix-like platforms (Mac OS & Linux)

Download the installer using curl or wget or your favorite program download files and run the script.
For eg:

    curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
    bash Mambaforge-$(uname)-$(uname -m).sh

or

    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
    bash Mambaforge-$(uname)-$(uname -m).sh

#### Uninstallation

Uninstalling Miniforge means removing the files that were created during the installation process.
You will typically want to remove:

1. Any modifications to your shell rc files that were made by Miniforge:

```bash
# Use this first command to see what rc files will be updated
conda init --reverse --dry-run
# Use this next command to take action on the rc files listed above
conda init --reverse
# Temporarily IGNORE the shell message 
#       'For changes to take effect, close and re-open your current shell.', 
# and CLOSE THE SHELL ONLY AFTER the 3rd step below is completed.
```

2. Remove the folder and all subfolders where the base environment for Miniforge was installed:

```bash
CONDA_BASE_ENVIRONMENT=$(conda info --base)
echo The next command will delete all files in ${CONDA_BASE_ENVIRONMENT}
# Warning, the rm command below is irreversible!
# check the output of the echo command above
# To make sure you are deleting the correct directory
rm -rf ${CONDA_BASE_ENVIRONMENT}
```

3. Any global conda configuration files that are left behind.

```bash
echo ${HOME}/.condarc will be removed if it exists
rm -f "${HOME}/.condarc"
```

### Windows

Download the installer and double click it on the file browser.

### Non-interactive install

For non-interactive usage one can use the batch install option:

    bash Miniforge3-Linux-x86_64.sh -b  # or similar for other installers for unix platforms

Look at the extra options by running the following:

    bash Miniforge3-Linux-x86_64.sh -h

or if you are on windows, run:

    start /wait "" Miniforge3-Windows-x86_64.exe /InstallationType=JustMe /RegisterPython=0 /S /D=%UserProfile%\Miniforge3

### Downloading the installer as part of a CI pipeline

If you wish to download the appropriate installer through the command line in a
more automated fashion, you may wish to a command similar to

For Linux, any architecture, use the following command

    wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

When you want to use `Mambaforge`, you should replace Miniforge into Mambaforge:

    wget -O Mambaforge.sh  "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"


For MacOSX, any architecture, use the following command

    curl -fsSLo Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh"

This will download the appropriate installer for the present architecture with
the filename ``Miniforge3.sh`` (or ``Mambaforge.sh``). Run the shell script with the command in batch
mode with the `-b` flash:

    bash Miniforge3.sh -b -p "${HOME}/conda"

`-p` is prefix option. A directory wil be createrd on `"${HOME}/conda"`.

Then you should create the path to conda and activate conda. 
Run this command:

    source "${HOME}/conda/etc/profile.d/conda.sh"

Finally, you can run the command to activate the base environment 

    conda activate

If you downloaded the Mambaforge installer, you should also run the following command after `source "${HOME}/conda/etc/profile.d/conda.sh`:

    source "${HOME}/conda/etc/profile.d/mamba.sh"



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
- Debian Bullseye (11)
- Ubuntu 16.04 ([LTS](https://ubuntu.com/about/release-cycle))
- Ubuntu 18.04 ([LTS](https://ubuntu.com/about/release-cycle))
- Ubuntu 20.04 ([LTS](https://ubuntu.com/about/release-cycle))
- Ubuntu 22.04 (Latest release -- also happens to be LTS)

## Local usage

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
  - At the time of writing, the is a sum of 72 artifacts, and with the two sources, we expect a grand total of 74 artifacts.
- Mark the pre-release as a release

NOTE: using a pre-release is important to make sure the latest links work.

## License

[BSD 3-Clause](./LICENSE)

## History

Relevant conversations:

- https://github.com/conda-forge/conda-forge.github.io/issues/871#issue-496677528
- https://github.com/conda-forge/conda-forge.github.io/pull/922
