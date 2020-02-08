#!/usr/bin/env bash

CURRENT_DIR=$(pwd)
QEMU_STATIC_VERSION=v3.1.0-3
QEMU_DIR="./build/qemu/"

qemu_ppc64le_sha256=d018b96e20f7aefbc50e6ba93b6cabfd53490cdf1c88b02e7d66716fa09a7a17
qemu_aarch64_sha256=a64b39b8ce16e2285cb130bcba7143e6ad2fe19935401f01c38325febe64104b
qemu_arm_sha256=f4184c927f78d23d199056c5b0b6d75855e298410571d65582face3159117901
qemu_x86_64_sha256=b9e444bf656c13a6db502f09e3135ef0c6045a117d5413662ba233d8b80f8fbd

mkdir -p $QEMU_DIR/
cd $QEMU_DIR/

wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-ppc64le-static
wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-aarch64-static
wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-arm-static
wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-x86_64-static

sha256sum qemu-ppc64le-static | grep -F "${qemu_ppc64le_sha256}"
sha256sum qemu-aarch64-static | grep -F "${qemu_aarch64_sha256}"
sha256sum qemu-arm-static | grep -F "${qemu_aarch64_sha256}"
sha256sum qemu-x86_64-static | grep -F "${qemu_x86_64_sha256}"

chmod +x qemu-ppc64le-static
chmod +x qemu-aarch64-static
chmod +x qemu-arm-static
chmod +x qemu-x86_64-static

cd $CURRENT_DIR
