#!/usr/bin/env bash
# Verify that the Miniforge installer provisions the base environment using ONLY
# the packages embedded in the installer, i.e. with NO network access at all.
#
# This is a regression guard for issues such as
#   https://github.com/conda-forge/miniforge/issues/883
# where the bundled mamba/micromamba (2.6.0) tried to download the *embedded*
# packages from conda.anaconda.org instead of unpacking them from the embedded
# payload. On a machine with working network access this fails silently -- the
# packages are simply downloaded -- so the only way to catch it in CI is to run
# the installer with outbound network access disabled.
#
# This script MUST be run in an environment where outbound network access is
# blocked, e.g.:
#   - Linux:   docker run --network none ... /construct/scripts/test_offline.sh
#   - macOS:   block the package hosts in /etc/hosts, then run it natively
#   - Windows: block the package hosts in the hosts file, then run it natively
# If the installer reaches for the network it will error out and this script
# will fail.
set -ex

echo "***** Start: Offline installer test *****"

CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-${PWD}}"
cd "${CONSTRUCT_ROOT}"

# Use a dedicated prefix so this never clashes with the networked test.
export CONDA_PATH="${HOME}/miniforge-offline"
# `conda`/`mamba` info & list are local operations; make sure nothing tries to
# opportunistically fetch channel notices and trip over the blocked network.
export CONDA_NUMBER_CHANNEL_NOTICES=0

echo "***** Locate the installer *****"
ls build/
if [[ "$(uname)" == MINGW* ]]; then
  EXT="exe"
else
  EXT="sh"
fi
INSTALLER_PATH=$(find build/ -name "*forge*.${EXT}" | head -n 1)
echo "Installer: ${INSTALLER_PATH}"

echo "***** Run the installer with the network blocked *****"
# If the embedded payload is not used, the installer will try to reach
# conda.anaconda.org and fail because there is no network.
if [[ "$(uname)" == MINGW* ]]; then
  echo "start /wait \"\" $(cygpath -w "${INSTALLER_PATH}") /InstallationType=JustMe /RegisterPython=0 /S /D=$(cygpath -w "${CONDA_PATH}")" > install_offline.bat
  cmd.exe //c install_offline.bat
  # Workaround a conda bug where it uses Unix style separators (mirrors test.sh)
  export PATH="${CONDA_PATH}/Library/bin:${PATH}"
  CONDA="conda.exe"
  # shellcheck disable=SC1091
  source "${CONDA_PATH}/Scripts/activate"
else
  chmod +x "${INSTALLER_PATH}"
  sh "${INSTALLER_PATH}" -b -p "${CONDA_PATH}"
  CONDA="conda"
  # shellcheck disable=SC1091
  source "${CONDA_PATH}/bin/activate"
fi

echo "***** Activate and inspect the base environment *****"
"${CONDA}" info
"${CONDA}" list

echo "***** The base environment must be complete (installed fully offline) *****"
conda_list=$("${CONDA}" list)
for pkg in python conda mamba pip; do
  if ! echo "${conda_list}" | grep -E "^${pkg}[[:space:]]" >/dev/null; then
    echo "ERROR: '${pkg}' is missing from the base environment" >&2
    exit 1
  fi
done

python -c "import sys; assert 'miniforge-offline' in sys.executable, sys.executable"
python -c "print('Offline install OK')"

echo "***** Done: Offline installer test *****"
