#!/bin/bash

set -eux

eval "$(PS1="${PS1-}" conda shell.posix activate)"

bash scripts/build.sh
# shellcheck disable=SC2154
if [[ "${ARCH}" == "$(uname -m)" ]]; then
  bash scripts/test.sh
fi
