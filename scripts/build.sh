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
pip install git+git://github.com/conda/constructor@1fb0463ce01734e95b35c12d8c7ecbc4b29cca85#egg=constructor --force --no-deps
conda list

echo "***** Make temp directory *****"
if [[ "$(uname)" == MINGW* ]]; then
   TEMP_DIR=$(mktemp -d --tmpdir=C:/Users/RUNNER~1/AppData/Local/Temp/);
else
   TEMP_DIR=$(mktemp -d);
fi

echo "***** Copy file for installer construction *****"
cp -R Miniforge3 $TEMP_DIR/
cp LICENSE $TEMP_DIR/

ls -al $TEMP_DIR

if [[ $TARGET_PLATFORM != win-* ]]; then
  CONDA_SUBDIR=$TARGET_PLATFORM conda create -n micromamba micromamba=0.8.2 -c conda-forge --yes
  MICROMAMBA_FILE=$(find $CONDA_PREFIX/pkgs -iname micromamba)
  EXTRA_CONSTRUCTOR_ARGS="$EXTRA_CONSTRUCTOR_ARGS --conda-exe $MICROMAMBA_FILE --platform $TARGET_PLATFORM"
fi

echo "***** Construct the installer *****"
constructor $TEMP_DIR/Miniforge3/ --output-dir $TEMP_DIR $EXTRA_CONSTRUCTOR_ARGS

echo "***** Generate installer hash *****"
cd $TEMP_DIR
if [[ "$(uname)" == MINGW* ]]; then
   EXT=exe;
else
   EXT=sh;
fi
# This line will break if there is more than one installer in the folder.
INSTALLER_PATH=$(find . -name "M*forge*.$EXT" | head -n 1)
HASH_PATH="$INSTALLER_PATH.sha256"
sha256sum $INSTALLER_PATH > $HASH_PATH

echo "***** Move installer and hash to build folder *****"
mkdir -p $CONSTRUCT_ROOT/build
mv $INSTALLER_PATH $CONSTRUCT_ROOT/build/
mv $HASH_PATH $CONSTRUCT_ROOT/build/

echo "***** Done: Building Miniforge installer *****"
cd $CONSTRUCT_ROOT
