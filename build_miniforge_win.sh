#!/usr/bin/env bash

set -ex

conda install posix --yes
source scripts/build.sh
source scripts/test.sh
