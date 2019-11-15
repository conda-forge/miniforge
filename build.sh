#!/usr/bin/env bash

set -exo pipefail

# Constructor should be >= 3.0.1 for aarch64.
# See https://github.com/conda-forge/miniforge/pull/2#issuecomment-554394343
conda install -y constructor>=3.0.1
conda list

TEMP_DIR=$(mktemp -d)

cd /construct

# Copy constructor spec to $TEMP_DIR
cp -R Miniforge3/ $TEMP_DIR/
cp LICENSE $TEMP_DIR

# Set the version of the installer from git
echo "version: $(git describe)" >> $TEMP_DIR/Miniforge3/construct.yaml

# Build the installer
constructor $TEMP_DIR/Miniforge3/ --output-dir $TEMP_DIR

# Fix permissions
mv $TEMP_DIR/Miniforge*.sh build/
chown 777 build/Miniforge*.sh
