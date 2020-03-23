#!/bin/bash

set -e
set -x

echo "Installing a fresh version of Miniforge3."
MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/download/4.8.3-1"
MINIFORGE_FILE="Miniforge3-4.8.3-1-MacOSX-x86_64.sh"
curl -L -O "${MINIFORGE_URL}/${MINIFORGE_FILE}"
bash $MINIFORGE_FILE -b

echo "Configuring conda."
source ~/miniconda3/bin/activate root
conda config --add channels conda-forge

export CONSTRUCT_ROOT=$PWD
mkdir -p build

bash scripts/build.sh
bash scripts/test.sh
