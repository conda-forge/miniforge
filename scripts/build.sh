#!/usr/bin/env bash

set -e

cd /construct

CONDA_VERSION=$(git tag --points-at HEAD)
CONDA_VERSION="4.7.11-0"
if [ -z "$CONDA_VERSION" ]
then
  echo "***** No Conda version detected in git tag.*****"
else
  CONDA_VERSION=$(echo $CONDA_VERSION | cut -d "-" -f 1)
  echo "***** Conda version detected in git tag: $CONDA_VERSION *****"
  echo "Install appropriate conda version."
  conda install -y "conda=$CONDA_VERSION"
fi

# Constructor should be >= 3.0.1 for aarch64.
# See https://github.com/conda-forge/miniforge/pull/2#issuecomment-554394343
echo "***** Install constructor *****"
conda install -y "constructor>=3.0.1"
conda list

echo "***** Make temp directory *****"
TEMP_DIR=$(mktemp -d)

echo "***** Copy file for installer construction *****"
cp -R Miniforge/ $TEMP_DIR/
cp LICENSE $TEMP_DIR

echo "***** Set installer version *****"
echo "version: $(git describe)" >> $TEMP_DIR/Miniforge/construct.yaml

echo "***** Construct the installer *****"
constructor $TEMP_DIR/Miniforge/ --output-dir $TEMP_DIR

echo "***** Move installer to build/ *****"
mv $TEMP_DIR/Miniforge*.sh /construct/build/
