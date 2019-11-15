#!/usr/bin/env bash

set -ex

cd /construct

echo "version: $(git describe)" >> Miniforge3/construct.yaml
constructor Miniforge3/ --output-dir build/
