#!/usr/bin/env bash

set -ex

conda install m2-base --yes
source scripts/build.sh
source scripts/test.sh
