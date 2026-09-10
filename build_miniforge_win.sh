#!/usr/bin/env bash

set -ex

# The legacy MSYS2 runtime in posix fails on ARM64; use the runner's Git Bash.
if [[ "${TARGET_PLATFORM}" != win-arm64 ]]; then
    conda install posix --yes
fi
source scripts/build.sh
pwsh -NoProfile -File scripts/test_windows.ps1 -Architecture "${ARCH}"
if [[ "${TARGET_PLATFORM}" == win-arm64 ]]; then
    # R is not yet published for win-arm64. NumPy is covered by test_windows.ps1.
    echo "ARM64 installer and NumPy tests passed; R integration requires target packages."
else
    source scripts/test.sh
fi
