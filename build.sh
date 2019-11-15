#!/usr/bin/env bash

set -ex

cd /construct

cp -R Miniforge3 build/Miniforge3/
cp LICENSE build/

echo "version: $(git describe)" >> build/Miniforge3/construct.yaml
constructor build/Miniforge3/ --output-dir build/

rm -fr build/Miniforge3/
rm -f build/LICENSE
