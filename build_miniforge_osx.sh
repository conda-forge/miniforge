#!/bin/bash

set -e
set -x

echo "Installing a fresh version of Miniforge3."
# Keep variable names in sync with
# https://github.com/conda-forge/docker-images/blob/main/scripts/run_commands
miniforge_arch="$(uname -m)"
miniforge_version="4.14.0-0"
condapkg="https://github.com/conda-forge/miniforge/releases/download/${miniforge_version}/Mambaforge-${miniforge_version}-MacOSX-${miniforge_arch}.sh"
if [ "$(uname -m)" = "x86_64" ]; then
   conda_checksum="949f046b4404cc8e081807b048050e6642d8db5520c20d5158a7ef721fbf76c5"
elif [ "$(uname -m)" = "arm64" ]; then
   conda_checksum="35d05a65e19b8e5d596964936ddd6023ae66d664a25ba291a52fec18f06a73b6"
else
   exit 1
fi
curl -s -L "$condapkg" -o miniconda.sh
openssl sha256 miniconda.sh | grep $conda_checksum

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
