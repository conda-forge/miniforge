#!/usr/bin/env bash

set -xe

env | sort

echo "***** Start: Building Miniforge installer(s) *****"
CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-${PWD}}"

cd "${CONSTRUCT_ROOT}"

echo "***** Install constructor *****"

mamba install --yes \
    --channel conda-forge --override-channels \
    jinja2 curl libarchive \
    "constructor>=3.4.5"

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
cp -R Miniforge3 "${TEMP_DIR}/"
cp LICENSE "${TEMP_DIR}/"

ls -al "${TEMP_DIR}"

if [[ "${TARGET_PLATFORM}" != win-* ]]; then
    MICROMAMBA_VERSION=1.5.7
    MICROMAMBA_BUILD=0
    mkdir "${TEMP_DIR}/micromamba"
    pushd "${TEMP_DIR}/micromamba"
    curl -L -O "https://anaconda.org/conda-forge/micromamba/${MICROMAMBA_VERSION}/download/${TARGET_PLATFORM}/micromamba-${MICROMAMBA_VERSION}-${MICROMAMBA_BUILD}.tar.bz2"
    bsdtar -xf "micromamba-${MICROMAMBA_VERSION}-${MICROMAMBA_BUILD}.tar.bz2"
    if [[ "${TARGET_PLATFORM}" == win-* ]]; then
      MICROMAMBA_FILE="${PWD}/Library/bin/micromamba.exe"
    else
      MICROMAMBA_FILE="${PWD}/bin/micromamba"
    fi
    popd
    EXTRA_CONSTRUCTOR_ARGS="${EXTRA_CONSTRUCTOR_ARGS} --conda-exe ${MICROMAMBA_FILE} --platform ${TARGET_PLATFORM}"
fi

echo "***** Construct the installer(s) *****"
# Transmutation requires the current directory is writable
cd "${TEMP_DIR}"
# shellcheck disable=SC2086
constructor "${TEMP_DIR}/Miniforge3/" --output-dir "${TEMP_DIR}" ${EXTRA_CONSTRUCTOR_ARGS}
cd -

echo "***** Generate installer hash *****"
cd "${TEMP_DIR}"
ls -alh
if [[ "$(uname)" == MINGW* ]]; then
   EXTS=("exe");
elif [[ "$(uname)" == Darwin ]]; then
   EXTS=("sh" "pkg");
else
   EXTS=("sh");
fi

for EXT in "${EXTS[@]}"; do
   # This line will break if there is more than one installer in the folder.
   INSTALLER_PATH=$(find . -name "M*forge*.${EXT}" | head -n 1)

   if [[ "${EXT}" == "pkg" && -n "${APPLE_NOTARIZATION_USERNAME:-}" ]]; then
      # notarize the PKG installer
      echo ""***** Notarizing the PKG installer "*****"
      scripts/notarize_osx_pkg.sh "${INSTALLER_PATH}"
   fi
   
   HASH_PATH="${INSTALLER_PATH}.sha256"
   sha256sum "${INSTALLER_PATH}" > "${HASH_PATH}"

   echo "***** Move .$EXT installer and hash to build folder *****"
   mkdir -p "${CONSTRUCT_ROOT}/build"
   mv "${INSTALLER_PATH}" "${CONSTRUCT_ROOT}/build/"
   mv "${HASH_PATH}" "${CONSTRUCT_ROOT}/build/"

   # copy the installer for latest
   if [[ "${MINIFORGE_NAME:-}" != "" && "${OS_NAME:-}" != "" && "${ARCH:-}" != "" ]]; then
      cp "${CONSTRUCT_ROOT}/build/${MINIFORGE_NAME}-"*"-${OS_NAME}-${ARCH}.${EXT}" "${CONSTRUCT_ROOT}/build/${MINIFORGE_NAME}-${OS_NAME}-${ARCH}.${EXT}"
   fi
done

cd "${CONSTRUCT_ROOT}"
echo "***** Done: Building Miniforge installer(s) *****"
