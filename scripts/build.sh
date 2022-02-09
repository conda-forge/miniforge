#!/usr/bin/env bash

set -xe

env | sort

echo "***** Start: Building Miniforge installer *****"
CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-${PWD}}"

cd "${CONSTRUCT_ROOT}"

# Constructor should be latest for non-native building
# See https://github.com/conda/constructor
echo "***** Install constructor *****"
# pyyaml 6 broke constructor
# https://github.com/conda/constructor/pull/473
conda install -y "constructor>=3.1.0" "pyyaml<6" jinja2 curl libarchive -c conda-forge --override-channels


if [[ "$(uname)" == "Darwin" ]]; then
    conda install -y coreutils -c conda-forge --override-channels
fi
# shellcheck disable=SC2154
if [[ "${TARGET_PLATFORM}" == win-* ]]; then
    conda install -y "nsis=3.01" -c conda-forge --override-channels
fi
pip install git+git://github.com/chrisburr/constructor@51415f3d62091daae7d21dab84add91d3cc73039#egg=constructor --force --no-deps
conda list

echo "***** Make temp directory *****"
if [[ "$(uname)" == MINGW* ]]; then
   TEMP_DIR=$(mktemp -d --tmpdir=C:/Users/RUNNER~1/AppData/Local/Temp/);
else
   TEMP_DIR=$(mktemp -d);
fi

echo "***** Copy file for installer construction *****"
cp -R Miniforge3 "${TEMP_DIR}/"
cp LICENSE "${TEMP_DIR}/"

ls -al "${TEMP_DIR}"

if [[ "${TARGET_PLATFORM}" != win-* ]]; then
    MICROMAMBA_VERSION=0.20.0
    mkdir "${TEMP_DIR}/micromamba"
    pushd "${TEMP_DIR}/micromamba"
    curl -L -O "https://anaconda.org/conda-forge/micromamba/${MICROMAMBA_VERSION}/download/${TARGET_PLATFORM}/micromamba-${MICROMAMBA_VERSION}-0.tar.bz2"
    bsdtar -xf "micromamba-${MICROMAMBA_VERSION}-0.tar.bz2"
    if [[ "${TARGET_PLATFORM}" == win-* ]]; then
      MICROMAMBA_FILE="${PWD}/Library/bin/micromamba.exe"
    else
      MICROMAMBA_FILE="${PWD}/bin/micromamba"
    fi
    popd
    EXTRA_CONSTRUCTOR_ARGS="${EXTRA_CONSTRUCTOR_ARGS} --conda-exe ${MICROMAMBA_FILE} --platform ${TARGET_PLATFORM}"
    conda install -y libmambapy
fi

echo "***** Construct the installer *****"
# Transmutation requires the current directory is writable
cd "${TEMP_DIR}"
# shellcheck disable=SC2086
constructor "${TEMP_DIR}/Miniforge3/" --output-dir "${TEMP_DIR}" ${EXTRA_CONSTRUCTOR_ARGS}
cd -

echo "***** Generate installer hash *****"
cd "${TEMP_DIR}"
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
