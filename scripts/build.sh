#!/usr/bin/env bash

set -xe

env | sort

echo "***** Start: Building Miniforge installer *****"
CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-${PWD}}"

cd "${CONSTRUCT_ROOT}"

echo "***** Install constructor *****"

MINIFORGE_CHANNEL_NAME="${MINIFORGE_CHANNEL_NAME:-conda-forge}"
mamba install --yes \
    --channel "${MINIFORGE_CHANNEL_NAME}" --override-channels \
    jinja2 curl libarchive \
    "constructor>=3.14.0"

if [[ "$(uname)" == "Darwin" ]]; then
    mamba install --yes \
        --channel "${MINIFORGE_CHANNEL_NAME}" --override-channels \
        coreutils
fi

mamba list

echo "***** Make temp directory *****"
if [[ "$(uname)" == MINGW* ]]; then
   # LOCALAPPDATA is a reference variable to the user's AppData\Local directory
   TEMP_DIR=$(mktemp -d --tmpdir="$LOCALAPPDATA/Temp/");
else
   TEMP_DIR=$(mktemp -d);
fi

echo "***** Copy file for installer construction *****"
cp -R Miniforge3 "${TEMP_DIR}/"
cp LICENSE "${TEMP_DIR}/"

ls -al "${TEMP_DIR}"

if [[ "${TARGET_PLATFORM}" != win-* ]]; then
    # Assumes specific structure in construct.yaml
    MICROMAMBA_VERSION=$(grep "set mamba_version" Miniforge3/construct.yaml | cut -d '=' -f 2 | cut -d '"' -f 2)
    MICROMAMBA_BUILD=1
    mkdir "${TEMP_DIR}/micromamba"
    pushd "${TEMP_DIR}/micromamba"
    MICROMAMBA_SOURCE_URL="${MICROMAMBA_SOURCE_URL:-https://anaconda.org/conda-forge/micromamba/${MICROMAMBA_VERSION}/download/${TARGET_PLATFORM}/micromamba-${MICROMAMBA_VERSION}-${MICROMAMBA_BUILD}.tar.bz2}"
    curl -L -O "${MICROMAMBA_SOURCE_URL}"
    $(which bsdtar || which tar) -xf "micromamba-${MICROMAMBA_VERSION}-${MICROMAMBA_BUILD}.tar.bz2"
    if [[ "${TARGET_PLATFORM}" == win-* ]]; then
      MICROMAMBA_FILE="${PWD}/Library/bin/micromamba.exe"
    else
      MICROMAMBA_FILE="${PWD}/bin/micromamba"
    fi
    popd
    EXTRA_CONSTRUCTOR_ARGS="${EXTRA_CONSTRUCTOR_ARGS} --conda-exe ${MICROMAMBA_FILE} --platform ${TARGET_PLATFORM}"
fi

echo "***** Set virtual package versions *****"
if [[ "${TARGET_PLATFORM}" == linux-* ]]; then
    export CONDA_OVERRIDE_GLIBC=2.17
elif [[ "${TARGET_PLATFORM}" == osx-64 ]]; then
    export CONDA_OVERRIDE_OSX=10.13
elif [[ "${TARGET_PLATFORM}" == osx-arm64 ]]; then
    export CONDA_OVERRIDE_OSX=11.0
fi

echo "***** Construct the installer *****"
# Transmutation requires the current directory is writable
cd "${TEMP_DIR}"
# shellcheck disable=SC2086
constructor "${TEMP_DIR}/Miniforge3/" --output-dir "${TEMP_DIR}" ${EXTRA_CONSTRUCTOR_ARGS}
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
INSTALLER_PATH=$(find . -name "M*forge*.${EXT}" | head -n 1)
HASH_PATH="${INSTALLER_PATH}.sha256"
sha256sum "${INSTALLER_PATH}" > "${HASH_PATH}"

echo "***** Move installer and hash to build folder *****"
mkdir -p "${CONSTRUCT_ROOT}/build"
mv "${INSTALLER_PATH}" "${CONSTRUCT_ROOT}/build/"
mv "${HASH_PATH}" "${CONSTRUCT_ROOT}/build/"

echo "***** Done: Building Miniforge installer *****"
cd "${CONSTRUCT_ROOT}"

# copy the installer for latest
if [[ "${OS_NAME:-}" != "" && "${ARCH:-}" != "" ]]; then
  cp "${CONSTRUCT_ROOT}/build/Miniforge3-"*"-${OS_NAME}-${ARCH}.${EXT}" "${CONSTRUCT_ROOT}/build/Miniforge3-${OS_NAME}-${ARCH}.${EXT}"
fi
