#!/usr/bin/env bash

set -exo pipefail

# Constructor should be >= 3.0.1 for aarch64.
# See https://github.com/conda-forge/miniforge/pull/2#issuecomment-554394343
conda install -y constructor>=3.0.1

cd /construct

# Copy constructor spec to build/
cp -R Miniforge3 build/Miniforge3/
cp LICENSE build/

# Set the version of the installer from git
echo "version: $(git describe)" >> build/Miniforge3/construct.yaml

# Build the installer
constructor build/Miniforge3/ --output-dir build/

# Files cleaning
rm -fr build/Miniforge3/
rm -f build/LICENSE
