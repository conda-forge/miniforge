#!/usr/bin/env bash

set -e

echo "***** Start: Building Miniforge installer *****"

CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-/construct}"

cd $CONSTRUCT_ROOT

# Constructor should be >= 3.0.1 for aarch64.
# See https://github.com/conda-forge/miniforge/pull/2#issuecomment-554394343
echo "***** Install constructor *****"
conda install -y "constructor>=3.0.1" jinja2
pip install git+git://github.com/conda/constructor@01209f0bf772c601dda062bc0167d0e00b70c6e4#egg=constructor --force --no-deps
conda list

echo "***** Make temp directory *****"
TEMP_DIR=$(mktemp -d)

echo "***** Copy file for installer construction *****"
cp -R Miniforge3 $TEMP_DIR/
cp LICENSE $TEMP_DIR/

ls -al $TEMP_DIR

echo "***** Construct the installer *****"
constructor $TEMP_DIR/Miniforge3/ --output-dir $TEMP_DIR

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
