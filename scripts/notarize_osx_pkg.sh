#!/usr/bin/env bash

# This script takes a macOS installer package (.pkg) and notarizes + staples it.
# It expects the following environment variables to be set:
# APPLE_NOTARIZATION_ISSUER_ID: Apple App Store Connect team identifier
# APPLE_NOTARIZATION_KEY_ID: Apple App Store Connect API key identifier
# APPLE_NOTARIZATION_AUTHKEY_PATH: Apple App Store Connect API AuthKey .p8 file path
# These can be obtained in https://appstoreconnect.apple.com/access/users > Integrations

set -euxo pipefail

if [ -z "${1:-}" ]; then
    echo "Usage: $0 <installer.pkg>"
    exit 1
else
    INSTALLER_PATH="$1"
fi

if [ ! -f "$INSTALLER_PATH" ]; then
    echo "Error: $INSTALLER_PATH does not exist"
    exit 1
fi

if [ "$(basename "$INSTALLER_PATH")" != "*.pkg" ]; then
    echo "Error: $INSTALLER_PATH is not a .pkg file"
    exit 1
fi

if [ "$(uname)" != "Darwin" ]; then
    echo "Error: $0 can only be run on macOS"
    exit 1
fi

if ! command -v xcrun >/dev/null; then
    echo "Error: xcrun is not installed"
    exit 1
fi

if ! command -v stapler >/dev/null; then
    echo "Error: stapler is not installed"
    exit 1
fi

if [ -z "${APPLE_NOTARIZATION_AUTHKEY_PATH:-}" ]; then
    echo "Error: APPLE_NOTARIZATION_AUTHKEY_PATH is not set"
    exit 1
fi

if [ -z "${APPLE_NOTARIZATION_KEY_ID:-}" ]; then
    echo "Error: APPLE_NOTARIZATION_KEY_ID is not set"
    exit 1
fi

if [ -z "${APPLE_NOTARIZATION_ISSUER_ID:-}" ]; then
    echo "Error: APPLE_NOTARIZATION_ISSUER_ID is not set"
    exit 1
fi

# Check signatures. If this fails, there's no point in attempting notarization.
pkgutil --check-signature "$INSTALLER_PATH"

# Submit for notarization to Apple servers
tmp_output_dir=$(mktemp -d)
json_output_file="${tmp_output_dir}/$(basename "$INSTALLER_PATH").notarization.json"
set +e
xcrun notarytool submit "$INSTALLER_PATH" \
    --key "$APPLE_NOTARIZATION_AUTHKEY_PATH" \
    --key-id "$APPLE_NOTARIZATION_KEY_ID" \
    --issuer "$APPLE_NOTARIZATION_ISSUER_ID" \
    --output-format json \
    --wait \
    --timeout 30m \
    | tee "$json_output_file"
notary_exit_code=$?
set -e
if [[ $notary_exit_code != 0 ]]; then
    submission_id=$(jq -r '.id' "$json_output_file")
    xcrun notarytool log "$submission_id" \
        --key "$APPLE_NOTARIZATION_AUTHKEY_PATH" \
        --key-id "$APPLE_NOTARIZATION_KEY_ID" \
        --issuer "$APPLE_NOTARIZATION_ISSUER_ID"
    exit $notary_exit_code
fi

# Staple
xcrun stapler staple --verbose "$INSTALLER_PATH"

# Check notarization status
spctl --assess -vv --type install "$INSTALLER_PATH" 2>&1 | tee /dev/stderr | grep accepted
