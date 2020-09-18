#!/usr/bin/env bash

set -e

echo "***** Start: Building Miniforge installer *****"

CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-/construct}"

cd $CONSTRUCT_ROOT

# Constructor should be latest for non-native building
# See https://github.com/conda/constructor
echo "***** Install constructor *****"
conda install -y "constructor>=3.1.0" jinja2
pip install git+git://github.com/conda/constructor@926707a34def8cb51be640b98842180260e7fa0a#egg=constructor --force --no-deps
conda list

echo "***** Make temp directory *****"
TEMP_DIR=$(mktemp -d)

echo "***** Copy file for installer construction *****"
cp -R Miniforge3 $TEMP_DIR/
cp LICENSE $TEMP_DIR/

ls -al $TEMP_DIR

if [[ $(uname -r) != "$ARCH" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
        # Use a x86_64 binary here since we don't have a standalone conda for arm64 yet.
        EXTRA_CONSTRUCTOR_ARGS="$EXTRA_CONSTRUCTOR_ARGS --conda-exe $CONDA_PREFIX/standalone_conda/conda.exe --platform osx-$ARCH"
    fi
fi

echo "***** Construct the installer *****"
constructor $TEMP_DIR/Miniforge3/ --output-dir $TEMP_DIR $EXTRA_CONSTRUCTOR_ARGS

echo "***** Generate installer hash *****"
cd $TEMP_DIR
# This line ill break if there is more than one installer in the folder.
INSTALLER_PATH=$(find . -name "Miniforge*.sh" | head -n 1)
HASH_PATH="$INSTALLER_PATH.sha256"
sha256sum $INSTALLER_PATH > $HASH_PATH

echo "***** Move installer and hash to build folder *****"
mv $INSTALLER_PATH $CONSTRUCT_ROOT/build/
mv $HASH_PATH $CONSTRUCT_ROOT/build/

echo "***** Done: Building Miniforge installer *****"
