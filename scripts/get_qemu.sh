#!/usr/bin/env bash
# Download and make qemu-user-static [1] executable in QEMU_DIR
# for various architectures (archs)
# [1]: https://github.com/multiarch/qemu-user-static/
set -e

CURRENT_DIR=$(pwd)
QEMU_DIR="./build/qemu/"
# qemu-user-static version and download URL
QEMU_STATIC_VERSION=v3.1.0-3
QEMU_REL_URL="https://github.com/multiarch/qemu-user-static/releases/download"

# Supported archs list
declare -a archs=("ppc64le" "aarch64" "arm" "x86_64")

# SHA256 of each architecture / archive: qemu-${arch}-static
ppc64le=d018b96e20f7aefbc50e6ba93b6cabfd53490cdf1c88b02e7d66716fa09a7a17
aarch64=a64b39b8ce16e2285cb130bcba7143e6ad2fe19935401f01c38325febe64104b
arm=f4184c927f78d23d199056c5b0b6d75855e298410571d65582face3159117901
x86_64=b9e444bf656c13a6db502f09e3135ef0c6045a117d5413662ba233d8b80f8fbd

mkdir -p $QEMU_DIR/
cd $QEMU_DIR/

for arch in "${archs[@]}"; do 
  echo "== qemu-user-static installation for ${arch} =="
  echo "- Dowloading ..."
  wget --quiet "${QEMU_REL_URL}/${QEMU_STATIC_VERSION}/qemu-${arch}-static"
  echo "- Verifying checksum ..."
  echo "${!arch} qemu-${arch}-static" | sha256sum --check
  echo "- Making it executable ..."
  chmod +x "qemu-${arch}-static"
done

cd $CURRENT_DIR
