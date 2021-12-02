#!/bin/bash

set -e
set -x

echo "Installing a fresh version of Miniforge3."
# Keep variable names in sync with 
# https://github.com/conda-forge/docker-images/blob/main/scripts/run_commands
miniforge_arch="$(uname -m)"
miniforge_version="4.10.3-10"
condapkg="https://github.com/conda-forge/miniforge/releases/download/${miniforge_version}/Mambaforge-${miniforge_version}-MacOSX-${miniforge_arch}.sh"
if [ "$(uname -m)" = "x86_64" ]; then
   conda_chksum="7c44259a0982cd3ef212649678af5f0dd4e0bb7306e8fffc93601dd1d739ec0b"
elif [ "$(uname -m)" = "arm64" ]; then
   conda_chksum="72bc86612ab9435915b616c2edb076737cbabe2c33fd684d58c2f9ae72e1957c"
else
   exit 1
fi
curl -s -L "$condapkg" > miniconda.sh
openssl sha256 miniconda.sh | grep $conda_chksum

bash miniconda.sh -b -p ~/conda

echo "Configuring conda."
# shellcheck disable=SC1090
source ~/conda/bin/activate root

export CONSTRUCT_ROOT="${PWD}"
mkdir -p build

bash scripts/build.sh
# shellcheck disable=SC2154
if [[ "${ARCH}" == "$(uname -m)" ]]; then
  bash scripts/test.sh
fi
