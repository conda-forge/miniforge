#!/usr/bin/env bash
# Download and make qemu-user-static [1] executable in QEMU_DIR
# for various architectures (archs)
# [1]: https://github.com/multiarch/qemu-user-static/
set -e

CURRENT_DIR=$(pwd)
QEMU_DIR="./build/qemu/"
# qemu-user-static version and download URL
QEMU_STATIC_VERSION=v5.1.0-7
QEMU_REL_URL="https://github.com/multiarch/qemu-user-static/releases/download"

# Supported archs list
declare -a archs=("ppc64le" "aarch64" "arm" "x86_64")

# SHA256 of each architecture / archive: qemu-${arch}-static
ppc64le=c850cb81287f9be43be181a6513803b03da5e1b76b9ab6d727566f1651889b37
aarch64=06664613db8785b600412d63b572f31edeafe0c06b655d51d16a536d27cdf47b
arm=977cd7e1a1cdcf53b3873f2348423fa29de99db5fa2ee77b4491039ae7e0600a
x86_64=d753aa1904531e251443b887e47b7e415fb8a99334225911250bef4c8ae4bc4e

mkdir -p $QEMU_DIR/
cd $QEMU_DIR/

for arch in "${archs[@]}"; do 
  echo "<-- qemu-user-static installation for ${arch}"
  echo "- Dowloading ..."
  wget --quiet "${QEMU_REL_URL}/${QEMU_STATIC_VERSION}/qemu-${arch}-static"
  echo "- Verifying checksum ..."
  echo "${!arch} qemu-${arch}-static" | sha256sum --check
  echo "- Making it executable ..."
  chmod +x "qemu-${arch}-static"
done

cd $CURRENT_DIR
