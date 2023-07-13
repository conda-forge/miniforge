#!/usr/bin/env bash

set -xe

env | sort

echo "***** Start: Building Miniforge installer *****"
CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-${PWD}}"

cd "${CONSTRUCT_ROOT}"

echo "***** Install constructor *****"

mamba install --yes \
    --channel conda-forge --override-channels \
    jinja2 curl libarchive \
    "constructor>=3.4.4"

if [[ "$(uname)" == "Darwin" ]]; then
    mamba install --yes \
        --channel conda-forge --override-channels \
        coreutils
fi

mamba list

echo "***** Make temp directory *****"
if [[ "$(uname)" == MINGW* ]]; then
   TEMP_DIR=$(mktemp -d --tmpdir=C:/Users/RUNNER~1/AppData/Local/Temp/);
else
   TEMP_DIR=$(mktemp -d);
fi

echo "***** Copy file for installer construction *****"
cp -R Miniforge3-uninstaller-patch "${TEMP_DIR}/"
cp LICENSE "${TEMP_DIR}/"

ls -al "${TEMP_DIR}"

echo "***** Construct the installer *****"
# Transmutation requires the current directory is writable
cd "${TEMP_DIR}"
# shellcheck disable=SC2086
constructor "${TEMP_DIR}/Miniforge3-uninstaller-patch/" --output-dir "${TEMP_DIR}" ${EXTRA_CONSTRUCTOR_ARGS:-}
cd -

echo "***** Generate installer hash *****"
cd "${TEMP_DIR}"
ls -alh
if [[ "$(uname)" == MINGW* ]]; then
   EXT="exe";
else
   EXT="sh";
fi
# This line will break if there is more than one installer in the folder.
INSTALLER_PATH=$(find . -iname "M*forge*.${EXT}" | head -n 1)
HASH_PATH="${INSTALLER_PATH}.sha256"
sha256sum "${INSTALLER_PATH}" > "${HASH_PATH}"

echo "***** Move installer and hash to build folder *****"
mkdir -p "${CONSTRUCT_ROOT}/build"
mv "${INSTALLER_PATH}" "${CONSTRUCT_ROOT}/build/"
mv "${HASH_PATH}" "${CONSTRUCT_ROOT}/build/"

echo "***** Done: Building Miniforge installer *****"
cd "${CONSTRUCT_ROOT}"

# copy the installer for latest
if [[ "${MINIFORGE_NAME:-}" != "" && "${OS_NAME:-}" != "" && "${ARCH:-}" != "" ]]; then
  cp "${CONSTRUCT_ROOT}/build/${MINIFORGE_NAME}-uninstaller-patch-"*"-${OS_NAME}-${ARCH}.${EXT}" "${CONSTRUCT_ROOT}/build/${MINIFORGE_NAME}-uninstaller-patch-${OS_NAME}-${ARCH}.${EXT}"
fi
