#!/usr/bin/env bash

set -xe

echo "***** Start: Building Miniforge installer *****"

CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-$PWD}"

cd $CONSTRUCT_ROOT

# Constructor should be latest for non-native building
# See https://github.com/conda/constructor
echo "***** Install constructor *****"
conda install -y "constructor>=3.1.0" jinja2 -c conda-forge -c defaults --override-channels
if [[ "$(uname)" == "Darwin" ]]; then
    conda install -y coreutils -c conda-forge -c defaults --override-channels
elif [[ "$(uname)" == MINGW* ]]; then
    conda install -y "nsis=3.01" -c conda-forge -c defaults --override-channels
fi
pip install git+git://github.com/conda/constructor@8c0121d3b81846de42973b52f13135f0ffeaddda#egg=constructor --force --no-deps
conda list

echo "***** Make temp directory *****"
TEMP_DIR=$(mktemp -d)

echo "***** Copy file for installer construction *****"
cp -R Miniforge3 $TEMP_DIR/
cp LICENSE $TEMP_DIR/

ls -al $TEMP_DIR

if [[ $(uname -r) != "$ARCH" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
        CONDA_SUBDIR=osx-arm64 conda create -n micromamba micromamba=0.6.5 -c https://conda-web.anaconda.org/conda-forge --yes
        EXTRA_CONSTRUCTOR_ARGS="$EXTRA_CONSTRUCTOR_ARGS --conda-exe $CONDA_PREFIX/envs/micromamba/bin/micromamba --platform osx-arm64"
    fi
fi

echo "***** Construct the installer *****"
constructor $TEMP_DIR/Miniforge3/ --output-dir $TEMP_DIR $EXTRA_CONSTRUCTOR_ARGS

echo "***** Generate installer hash *****"
cd $TEMP_DIR
# This line ill break if there is more than one installer in the folder.
INSTALLER_PATH=$(find . -name "*forge*.sh" -or -name "*forge*.exe" | head -n 1)
HASH_PATH="$INSTALLER_PATH.sha256"
sha256sum $INSTALLER_PATH > $HASH_PATH

echo "***** Move installer and hash to build folder *****"
mkdir -p $CONSTRUCT_ROOT/build
mv $INSTALLER_PATH $CONSTRUCT_ROOT/build/
mv $HASH_PATH $CONSTRUCT_ROOT/build/

echo "***** Done: Building Miniforge installer *****"
