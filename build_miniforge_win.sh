#!/usr/bin/env bash

set -ex

if [[ "${TARGET_PLATFORM}" == win-arm64 ]]; then
    # There is no win-arm64 Miniforge to bootstrap from yet, so create a native
    # win-arm64 environment from the x64 one and build from there.
    mamba create --yes --name bootstrap --platform win-arm64 \
        --channel "${MINIFORGE_CHANNEL_NAME:-conda-forge}" --override-channels \
        python=3.14 m2-base mamba
    conda activate bootstrap
else
    conda install m2-base --yes
fi
source scripts/build.sh
source scripts/test.sh
