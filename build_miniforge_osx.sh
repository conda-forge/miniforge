#!/bin/bash

set -e
set -x

echo "Installing a fresh version of Miniconda."
MINICONDA_URL="https://repo.continuum.io/miniconda"
MINICONDA_FILE="Miniconda3-latest-MacOSX-x86_64.sh"
curl -L -O "${MINICONDA_URL}/${MINICONDA_FILE}"
bash $MINICONDA_FILE -b

echo "Configuring conda."
source ~/miniconda3/bin/activate root
conda config --add channels conda-forge

export CONSTRUCT_ROOT=$PWD
source scripts/build.sh
source scripts/test.sh
