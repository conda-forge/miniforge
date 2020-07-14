#!/bin/sh
# install_miniforge.sh -- install miniforge on Linux of MacOS

__THIS_PATH="${0}"
__THIS_FILE="$(basename "${__THIS_PATH}")"

print_usage() {
    echo "Install Miniforge on Linux or MacOS" 
    echo "Usage: ${__THIS_FILE} [-h] [Miniforge3.sh arguments]"
    # echo ""
    # echo "(*) To install on Windows, uname, curl or wget, and sh must be installed."
    echo ""
    echo "If KERNEL_NAME, MARCH, and RELEASE are not specified, on this platform,"
    echo "the defaults are:"
    echo ""
    echo " KERNEL_NAME=$(uname -s)"
    echo " MARCH=$(uname -m)"
    echo " RELEASE=latest"
    echo ""
    echo "## Examples:"
    echo "### Download and run Miniforge3.sh interactively:"
    echo "${__THIS_PATH}"
    echo ""
    echo "### Download Linux aarch64 latest and run Miniforge.sh interactively:"
    echo "KERNEL_NAME=Linux MARCH=aarch64 RELEASE=latest ${__THIS_PATH}"
    echo ""
    echo "### Download and run non-interactively (in batch mode):"
    echo "${__THIS_PATH} -b -p \"${HOME}/miniforge3\""
    echo ""
}

main() {
    for arg in "${@}"; do
        case "${arg}" in
            -h|--help)
                print_usage
                exit 0
                ;;
            test)
                (set -e -x; run_tests)
                exit $?
                ;;
            --install-mamba)
                INSTALL_MAMBA=1
                shift
                ;;
        esac
    done
    KERNEL_NAME="${KERNEL_NAME:-"$(uname)"}"
    MARCH="${MARCH:-"$(uname -m)"}"
    if [ "${MARCH}" = "Darwin" ]; then
        MARCH="MacOSX"
    fi

    RELEASE="${RELEASE:-"latest"}"

    MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/${RELEASE}/download/Miniforge3-${KERNEL_NAME}-${MARCH}.sh"
    MINIFORGE_SH="Miniforge3.sh"
    MINIFORGE_SHA256="${MINIFORGE_SH}.sha256"
    MINIFORGE_SHA256_URL="${MINIFORGE_URL}.sha256"
    download "${MINIFORGE_URL}" "${MINIFORGE_SH}"

    # TODO FIXME XXX: determine the version number for the .sha256 URL
    if [ "${RELEASE}" != "latest" ]; then
        download "${MINIFORGE_SHA256_URL}" "${MINIFORGE_SHA256}"
        check_sha256 "${MINIFORGE_SHA256}"
        if [ $? -gt 0 ]; then
            echo "ERROR: Checksum failed. You might try running this script again."
            exit 3
        fi
    fi

    sh "${MINIFORGE_SH}" "${@}"

    if [ -n "${INSTALL_MAMBA}" ]; then
        # shellcheck disable=SC1090
        # shellcheck source=~/.bashrc
        . "${HOME}/.bashrc"
        echo PATH="${PATH}"
        conda install -y mamba -n root -c conda-forge
    fi
}

download() {
    url=$1
    dest=$2
    if [ -n "${SKIP_DOWNLOAD}" ]; then
        return 0
    fi
    if hash wget; then
        wget "${url}" -O "${dest}"
    elif hash curl; then
        curl "${url}" -o "${dest}"
    else
        echo "ERROR: Neither wget nor curl were found in \$PATH"
    fi
}

check_sha256() {
    checksum_file="${1}"
    sha256sum -c "${checksum_file}"
}

run_tests() {
    KERNEL_NAME="Linux" MARCH="x86_64" RELEASE=latest main
    KERNEL_NAME="Linux" MARCH="aarch64" RELEASE=latest main
    KERNEL_NAME="Linux" MARCH="ppc64le" RELEASE=latest main
    KERNEL_NAME="MacOSX" MARCH="x86_64" RELEASE=latest main
}

main "${@}"
