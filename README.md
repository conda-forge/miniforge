# Miniforge

[![Build miniforge](https://github.com/conda-forge/miniforge/actions/workflows/ci.yml/badge.svg)](https://github.com/conda-forge/miniforge/actions/workflows/ci.yml)
[![GitHub downloads](https://img.shields.io/github/downloads/conda-forge/miniforge/total.svg)](https://tooomm.github.io/github-release-stats/?username=conda-forge&repository=miniforge)

This repository holds the minimal installers for [Conda](https://conda.io/) and [Mamba](https://github.com/mamba-org/mamba) specific to [conda-forge](https://conda-forge.org/), with the following features pre-configured:

* Packages in the base environment are obtained from the [conda-forge channel](https://anaconda.org/conda-forge).
* The [conda-forge](https://conda-forge.org/) channel is set as the default (and only) channel.

We put an emphasis on supporting various CPU architectures (x86_64, ppc64le, and aarch64 including Apple Silicon).

<details>

<summary>🚨 PyPy support is deprecated (<b>Deprecated</b> as of August 2024) 🚨</summary>

TL;DR: We are planning to remove PyPy from conda-forge feedstock recipes in a
few weeks (and thus to stop building new releases of packages for PyPy), unless
there is substantial enough interest to justify the continued maintenance
effort.

To help with this transition, the latest installers will:

* The installer will refuse to proceed every two weeks in October
* The installer will refuse to proceed every ten days in November
* The installer will refuse to proceed every five days in December
* The installer will refuse to proceed in 2025+

### Miniforge-pypy3

Latest installers with PyPy 3.9 in the base environment are listed below.
However, the latest installers will cease to work and will stop being made available in 2025.
You should therefore pin to 24.7.0 if you require PyPy3.

| OS      | Architecture       | Minimum Version | Miniforge Version                                                          |
| ------- | ------------------ | --------------- | -------------------------------------------------------------------------- |
| Linux   | x86_64 (amd64)     | glibc >= 2.17   | [24.9.2-0](https://github.com/conda-forge/miniforge/releases/tag/24.9.2-0) |
| Linux   | x86_64 (amd64)     | glibc >= 2.12   | [24.3.0-0](https://github.com/conda-forge/miniforge/releases/tag/24.3.0-0) |
| Linux   | aarch64 (arm64)    | glibc >= 2.17   | [24.9.2-0](https://github.com/conda-forge/miniforge/releases/tag/24.9.2-0) |
| Linux   | aarch64 (arm64)    | glibc >= 2.12   | [24.3.0-0](https://github.com/conda-forge/miniforge/releases/tag/24.3.0-0) |
| Linux   | ppc64le (POWER8/9) | glibc >= 2.17   | [24.9.2-0](https://github.com/conda-forge/miniforge/releases/tag/24.9.2-0) |
| Linux   | ppc64le (POWER8/9) | glibc >= 2.12   | [24.3.0-0](https://github.com/conda-forge/miniforge/releases/tag/24.3.0-0) |
| macOS   | x86_64             | macOS >= 10.13  | [24.9.2-0](https://github.com/conda-forge/miniforge/releases/tag/24.9.2-0) |
| macOS   | x86_64             | macOS >= 10.9   | [24.3.0-0](https://github.com/conda-forge/miniforge/releases/tag/24.3.0-0) |
| Windows | x86_64             | Windows >= 7    | [24.9.2-0](https://github.com/conda-forge/miniforge/releases/tag/24.9.2-0) |

</details>

<details>

<summary>🚨 Mambaforge (<b>Deprecated</b> as of July 2024) 🚨</summary>

Update for July 2024:

As of July 2024, `Mambaforge` is deprecated. We suggest users switch to
`Miniforge3` immediately. These installers will be retired from new releases
after January 2025. To assist in the migration, we will be introducing rollowing
brownouts to the latest Mambaforge installer. Installers up to version 24.5.0-1
will not have any brownouts. 24.5.0-1 will include a warning message.
Installers 2024.5.0-2 and later will have the following brownout schedule:

* The installer will refuse to proceed every two weeks in October
* The installer will refuse to proceed every ten days in November
* The installer will refuse to proceed every five days in December
* The installer will refuse to proceed in 2025+

Previous information:

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

You can still find the latest installers in the [24.9.2 release](https://github.com/conda-forge/miniforge/releases/tag/24.9.2-0).

</details>


## Usage

Miniforge provides installers for the commands [`conda`](https://conda.io/) and
[`mamba`](https://github.com/mamba-org/mamba).  Once the installer for your OS
and architecture has been executed, you should be able to use these commands in
a terminal.

### conda/mamba usable in any terminals

However, with the default choices of the Windows installer, these commands are
only available in the "Anaconda Prompt". To be able to use these commands in
other terminals, one needs to initialize conda for your shell by running in
the Anaconda Prompt

```sh
conda init
```

Note that one can also just add the `C:\Users\myusername\miniforge3\condabin` folder
to the path environment variable
[manually](https://learn.microsoft.com/en-us/previous-versions/office/developer/sharepoint-2010/ee537574(v=office.14)#to-add-a-path-to-the-path-environment-variable)
so `conda` and `mamba` may be used more conveniently from any command prompt with limited
chance of software conflicts.

The same situation arises on Unix if you use the non-interactive install.
Initialization can be done by calling conda with its full path, with something like

```sh
~/miniforge3/bin/conda init
```

### Automatic activation of environments

By default, once conda has been initialized for your shell, the `base` environment is
activated so that the command `python` corresponds to the base Python provided by
Miniforge and `conda install` installs packages in the `base` environment. This can
be convenient for but it is cleaner to deactivate this automatic activation with

```sh
conda config --set auto_activate_base false
```

and use `conda` or `mamba` to create and activate other environments, with for example
(to create an environment called `main`)

```sh
conda create --name main jupyterlab numpy pandas
conda activate main
```

Finally, it is also possible to add to your shell configuration file
(typically `~/.bashrc` or `~/.zshrc` on Unix;
on Windows, edit with `notepad $PROFILE`) the activation command.

## Requirements and installers

Latest installers with Python 3.12 `(*)` in the base environment:

| OS      | Architecture                  | Minimum Version | File                            |
| ------- | ----------------------------- | --------------- | ------------------------------- |
| Linux   | x86_64 (amd64)                | glibc >= 2.17   | `Miniforge3-Linux-x86_64.sh`    |
| Linux   | aarch64 (arm64) `(**)`        | glibc >= 2.17   | `Miniforge3-Linux-aarch64.sh`   |
| Linux   | ppc64le (POWER8/9)            | glibc >= 2.17   | `Miniforge3-Linux-ppc64le.sh`   |
| macOS   | x86_64                        | macOS >= 10.13  | `Miniforge3-MacOSX-x86_64.sh`   |
| macOS   | arm64 (Apple Silicon) `(***)` | macOS >= 11.0   | `Miniforge3-MacOSX-arm64.sh`    |
| Windows | x86_64                        | Windows >= 7    | `Miniforge3-Windows-x86_64.exe` |

`(*)` The Python version is specific only to the base environment. Conda can create new environments with different Python versions and implementations.

`(**)` For Raspberry PI that include a 64 bit processor, you must also use
a 64-bit operating system such as
[Raspberry Pi OS 64-bit](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit)
or
[Ubuntu for Raspberry PI](https://ubuntu.com/raspberry-pi).
The versions listed as "System: 32-bit" are not compatible with the installers on this website.

`(***)` Apple silicon builds are experimental and haven't had testing like the other platforms.

## Install

### Windows

Download and execute [the Windows installer](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe).
Follow the prompts, taking note of the options to
"Create start menu shortcuts" and "Add Miniforge3 to my PATH environment variable". The latter is
not selected by default due to potential conflicts with other software. Without Miniforge3 on the
path, the most convenient way to use the installed software (such as commands `conda` and `mamba`)
will be via the "Miniforge Prompt" installed to the start menu.

There are known issues with the usage of special characters and spaces in
the installation location, see for example
https://github.com/conda-forge/miniforge/issues/484.
We recommend users install in a directory without any such characters in the name.

For non-interactive usage one can use the batch install option:

```sh
start /wait "" Miniforge3-Windows-x86_64.exe /InstallationType=JustMe /RegisterPython=0 /S /D=%UserProfile%\Miniforge3
```

### Unix-like platforms (macOS & Linux)

Download the installer using curl or wget or your favorite program. For eg:

```sh
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
```

or

```sh
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
```

Run the script with:

```sh
bash Miniforge3-$(uname)-$(uname -m).sh
```

The interactive installation will prompt you to initialize conda with your shell.
This is typically with recommended workflow.

For non-interactive install (for example on a CI), the following command can be used
(call with `-h` to list the extra options):

```sh
bash Miniforge3-$(uname)-$(uname -m).sh -b
```

In non-interactive installations, the conda initialization commands will not be run by default.

Note that on macOS, Miniforge can also be installed with [Homebrew](https://brew.sh/).

### As part of a CI pipeline

If you wish to download the appropriate installer through the command line in a
more automated fashion, you may wish to a command similar to

For Linux, any architecture, use the following command

```sh
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
```

For macOS, any architecture, use the following command

```sh
curl -fsSLo Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh"
```

This will download the appropriate installer for the present architecture with
the filename `Miniforge3.sh`. Run the shell script with the command in batch
mode with the `-b` flash:

```sh
bash Miniforge3.sh -b -p "${HOME}/conda"
```

`-p` is prefix option. A directory will be created on `"${HOME}/conda"`.

Then you should create the path to conda and activate conda.
Run this command:

```sh
source "${HOME}/conda/etc/profile.d/conda.sh"
# For mamba support also run the following command
source "${HOME}/conda/etc/profile.d/mamba.sh"
```

Finally, you can run the command to activate the base environment

```sh
conda activate
```


## Uninstall

### Unix-like platforms (macOS & Linux)

Uninstalling Miniforge means removing the files that were created during the installation process.
You will typically want to remove:

1. Any modifications to your shell rc files that were made by Miniforge:

```sh
# Use this first command to see what rc files will be updated
conda init --reverse --dry-run
# Use this next command to take action on the rc files listed above
conda init --reverse
# Temporarily IGNORE the shell message
#       'For changes to take effect, close and re-open your current shell.',
# and CLOSE THE SHELL ONLY AFTER the 3rd step below is completed.
```

2. Remove the folder and all subfolders where the base environment for Miniforge was installed:

```sh
CONDA_BASE_ENVIRONMENT=$(conda info --base)
echo The next command will delete all files in ${CONDA_BASE_ENVIRONMENT}
# Warning, the rm command below is irreversible!
# check the output of the echo command above
# To make sure you are deleting the correct directory
rm -rf ${CONDA_BASE_ENVIRONMENT}
```

3. Any global conda configuration files that are left behind.

```sh
echo ${HOME}/.condarc will be removed if it exists
rm -f "${HOME}/.condarc"
echo ${HOME}/.conda and underlying files will be removed if they exist.
rm -fr ${HOME}/.conda
```


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
- Ubuntu 22.04 ([LTS](https://ubuntu.com/about/release-cycle))
- Ubuntu 24.04 (Latest release -- also happens to be LTS)


## Building a Miniforge Installer

Installers are built and uploaded via the CI but if you want to construct your own Miniforge installer, here is how:

```sh
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

As of June 2024, Mambaforge is deprecated and will be retired in January 2025.
We recommend users switch to Miniforge3 immediately. For more details, please
see the note above.


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
