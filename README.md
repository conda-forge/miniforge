# Miniforge
[![Build miniforge](https://github.com/conda-forge/miniforge/actions/workflows/ci.yml/badge.svg)](https://github.com/conda-forge/miniforge/actions/workflows/ci.yml)
[![GitHub downloads](https://img.shields.io/github/downloads/conda-forge/miniforge/total.svg)](https://tooomm.github.io/github-release-stats/?username=conda-forge&repository=miniforge)

This repository holds the minimal installers for [Conda](https://conda.io/) and [Mamba](https://github.com/mamba-org/mamba) specific to [conda-forge](https://conda-forge.org/), with the following features pre-configured:

* Packages in the base environment are obtained from the [conda-forge channel](https://anaconda.org/conda-forge).
* The [conda-forge](https://conda-forge.org/) channel is set as the default (and only) channel.

We put an emphasis on supporting various CPU architectures (x86_64, ppc64le, and aarch64 including Apple Silicon). Optional support for PyPy in place of standard Python interpreter (aka "CPython") is provided in the installers with `-pypy3-` in their filename.

## Download

Miniforge installers are available here: https://github.com/conda-forge/miniforge/releases

#### Miniforge3

Latest installers with Python 3.10 `(*)` in the base environment:

| OS      | Architecture                  | Minimum Version  | Download  |
| --------|-------------------------------|------------------|-----------|
| Linux   | x86_64 (amd64)                | glibc >= 2.17    | [Miniforge3-Linux-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh) |
| Linux   | aarch64 (arm64) `(**)`        | glibc >= 2.17    | [Miniforge3-Linux-aarch64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh) |
| Linux   | ppc64le (POWER8/9)            | glibc >= 2.17    | [Miniforge3-Linux-ppc64le](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-ppc64le.sh) |
| OS X    | x86_64                        | macOS >= 10.13   | [Miniforge3-MacOSX-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh) |
| OS X    | arm64 (Apple Silicon) `(***)` | macOS >= 11.0    | [Miniforge3-MacOSX-arm64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh) |
| Windows | x86_64                        | Windows >= 7     | [Miniforge3-Windows-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe) |

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

| OS      | Architecture       | Minimum Version  | Download  |
| --------|--------------------|------------------|-----------|
| Linux   | x86_64 (amd64)     | glibc >= 2.17    | [Miniforge-pypy3-Linux-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Linux-x86_64.sh) |
| Linux   | aarch64 (arm64)    | glibc >= 2.17    | [Miniforge-pypy3-Linux-aarch64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Linux-aarch64.sh) |
| Linux   | ppc64le (POWER8/9) | glibc >= 2.17    | [Miniforge-pypy3-Linux-ppc64le](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Linux-ppc64le.sh) |
| OS X    | x86_64             | macOS >= 10.13   | [Miniforge-pypy3-MacOSX-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-MacOSX-x86_64.sh) |
| Windows | x86_64             | Windows >= 7     | [Miniforge-pypy3-Windows-x86_64](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge-pypy3-Windows-x86_64.exe) |

<details>

<summary>🚨 Mambaforge (<b>Deprecated</b> as of July 2024) 🚨</summary>

With the [release](https://github.com/conda-forge/miniforge/releases/tag/23.3.1-0) of
`Miniforge3-23.3.1-0`, that incorporated the changes in
[#277](https://github.com/conda-forge/miniforge/pull/277), the packages and
configuration of `Mambaforge` and `Miniforge3` are now **identical**. The
only difference between the two is the name of the installer and, subsequently,
the default installation directory.

We recommend switching to `Miniforge3` immediately. These installers will be 
retired in January 2025. To assist in the migration to Miniforge3 for CI users, we've stopped
the latest Mambaforge (24.5+) installer from proceeding with following schedule

* Every two weeks in October
* Every ten days in November
* Every five days in December
* Never in 2025

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

</details>

## Install

### Unix-like platforms (Mac OS & Linux)

Download the installer using curl or wget or your favorite program and run the script.
For eg:

    curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    bash Miniforge3-$(uname)-$(uname -m).sh

or

    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    bash Miniforge3-$(uname)-$(uname -m).sh

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
echo ${HOME}/.conda and underlying files will be removed if they exist.
rm -fr ${HOME}/.conda
```

### Windows

Download and execute the Windows installer. Follow the prompts, taking note of the options to
"Create start menu shortcuts" and "Add Miniforge3 to my PATH environment variable". The latter is
not selected by default due to potential conflicts with other software. Without Miniforge3 on the
path, the most convenient way to use the installed software (such as commands `conda` and `mamba`)
will be via the "Miniforge Prompt" installed to the start menu.

There are known issues with the usage of special characters and spaces in
the installation location, see for example
https://github.com/conda-forge/miniforge/issues/484.
We recommend users install in a directory without any such characters in the name.

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


For MacOSX, any architecture, use the following command

    curl -fsSLo Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh"

This will download the appropriate installer for the present architecture with
the filename ``Miniforge3.sh``. Run the shell script with the command in batch
mode with the `-b` flash:

    bash Miniforge3.sh -b -p "${HOME}/conda"

`-p` is prefix option. A directory wil be created on `"${HOME}/conda"`.

Then you should create the path to conda and activate conda.
Run this command:

    source "${HOME}/conda/etc/profile.d/conda.sh"
    # For mamba support also run the following command
    source "${HOME}/conda/etc/profile.d/mamba.sh"

Finally, you can run the command to activate the base environment

    conda activate


### Homebrew

On macOS, you can install miniforge with [Homebrew](https://brew.sh/) by running

    brew install miniforge

## Usage

If Miniforge is on the system path (default on Mac and Linux), its versions of the
[`conda`](https://conda.io/projects/conda/en/latest/user-guide/getting-started.html#managing-environments) and
[`mamba`](https://mamba.readthedocs.io/en/latest/user_guide/mamba.html#mamba-user-guide) programs can be used
at any command prompt. The most notable difference is that the default channel for packages will be conda-forge.

On Windows, Miniforge is not added to the system path by default. In this case, `conda`/`mamba` cannot be used from
ordinary command prompts without the full path of the executables, e.g. `C:\Users\myusername\miniforge3\condabin\conda`.
Instead, it is recommended to use the Miniforge Prompt, available from the Start menu. If desired, the
`C:\Users\myusername\miniforge3\condabin` folder may be added to the path environment variable
[manually](https://learn.microsoft.com/en-us/previous-versions/office/developer/sharepoint-2010/ee537574(v=office.14)#to-add-a-path-to-the-path-environment-variable)
after installation so the software may be used more conveniently from any command prompt with limited chance of software conflicts.

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
- Debian Bullseye (11)
- Debian Bookworm (12)
- Ubuntu 16.04 ([LTS](https://ubuntu.com/about/release-cycle))
- Ubuntu 18.04 ([LTS](https://ubuntu.com/about/release-cycle))
- Ubuntu 20.04 ([LTS](https://ubuntu.com/about/release-cycle))
- Ubuntu 22.04 (Latest release -- also happens to be LTS)

## Building a Miniforge Installer

Installers are built and uploaded via the CI but if you want to construct your own Miniforge installer, here is how:

```bash
# Configuration
export ARCH=aarch64
export DOCKERIMAGE=condaforge/linux-anvil-aarch64

bash build_miniforge.sh
```

## Support for older operating systems

### Support for macOS 10.9-10.12
If you require support for macOS 10.9 through 10.12 you may download version
24.3.0-0 of miniforge available at 
https://github.com/conda-forge/miniforge/releases/tag/24.3.0-0

### Support for glibc 2.12-2.16

If you require support for glibc 2.12 through 2.16 you may download version
24.3.0-0 of miniforge available at 
https://github.com/conda-forge/miniforge/releases/tag/24.3.0-0

## FAQ

### What's the difference between Mambaforge and Miniforge?

After the release of Miniforge 23.3.1 in August 2023, Miniforge and Mambaforge
are essentially identical. The only difference is the name of the installer and
subsequently the default installation path.

Before that release, Miniforge only shipped conda, while Mambaforge added mamba
on top. Since Miniconda started shipping conda-libmamba-solver in July 2023,
Miniforge followed suit and started shipping it too in August. At that point,
since conda-libmamba-solver depends on libmambapy, the only difference between
Miniforge and Mambaforge was the presence of the mamba Python package. To
minimize surprises, we decided to add mamba to Miniforge too.

### Should I choose one or another going forward at the risk of one of them getting deprecated?

Given its wide usage, there are no plans to deprecate Mambaforge. If at some
point we decide to deprecate Mambaforge, it will be appropriately announced and
communicated with sufficient time in advance.

That said, if you had to start using one today, we recommend to stick to
Miniforge.


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
