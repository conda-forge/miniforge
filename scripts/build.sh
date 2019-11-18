#!/usr/bin/env bash

set -ex

# Constructor should be >= 3.0.1 for aarch64.
# See https://github.com/conda-forge/miniforge/pull/2#issuecomment-554394343
echo "***** Install constructor *****"
conda install -y constructor
conda list

echo "***** Make temp directory *****"
TEMP_DIR=$(mktemp -d)

echo "***** Copy file for installer construction *****"
cp -R $FEEDSTOCK_ROOT/Miniforge3/ $TEMP_DIR/
cp $FEEDSTOCK_ROOT/LICENSE $TEMP_DIR

echo "***** Set installer version *****"
echo "version: $(git describe)" >> $TEMP_DIR/Miniforge3/construct.yaml

echo "***** Construct the installer *****"
constructor $TEMP_DIR/Miniforge3/ --output-dir $TEMP_DIR

echo "***** Move installer to build/ *****"
mkdir -p $FEEDSTOCK_ROOT/build/
chmod 777 $FEEDSTOCK_ROOT/build/
mv $TEMP_DIR/Miniforge*.sh $FEEDSTOCK_ROOT/build/
