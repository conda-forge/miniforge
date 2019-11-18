#!/usr/bin/env bash

set -e

# Constructor should be >= 3.0.1 for aarch64.
# See https://github.com/conda-forge/miniforge/pull/2#issuecomment-554394343
echo "***** Install constructor *****"
conda install -y constructor
conda list

echo "***** Make temp directory *****"
TEMP_DIR=$(mktemp -d)

cd /construct

echo "***** Copy file for installer construction *****"
cp -R Miniforge3/ $TEMP_DIR/
cp LICENSE $TEMP_DIR

echo "***** Set installer version *****"
echo "version: $(git describe)" >> $TEMP_DIR/Miniforge3/construct.yaml

echo "***** Construct the installer *****"
constructor $TEMP_DIR/Miniforge3/ --output-dir $TEMP_DIR

echo "***** Move installer to build/ *****"
mv $TEMP_DIR/Miniforge*.sh /construct/build/
