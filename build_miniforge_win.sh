#!/usr/bin/env bash

set -ex

# The legacy MSYS2 runtime in posix fails on ARM64; use the runner's Git Bash.
if [[ "${TARGET_PLATFORM}" != win-arm64 ]]; then
    conda install posix --yes
fi
source scripts/build.sh
source scripts/test.sh
