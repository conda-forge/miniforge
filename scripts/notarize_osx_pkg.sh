#!/bin/sh

# This script takes a macOS installer package (.pkg) and notarizes it.
# It expects the following environment variables to be set:
# APPLE_NOTARIZATION_USERNAME: Apple ID username
# APPLE_NOTARIZATION_PASSWORD: Apple ID password
# APPLE_NOTARIZATION_TEAM_ID: Apple ID team identifier

set -euxo pipefail

if [ -n "$1" ]; then
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

if [ -z "${APPLE_NOTARIZATION_USERNAME:-}" ]; then
    echo "Error: APPLE_NOTARIZATION_USERNAME is not set"
    exit 1
fi

if [ -z "${APPLE_NOTARIZATION_PASSWORD:-}" ]; then
    echo "Error: APPLE_NOTARIZATION_USERNAME is not set"
    exit 1
fi

if [ -z "${APPLE_NOTARIZATION_TEAM_ID:-}" ]; then
    echo "Error: APPLE_NOTARIZATION_USERNAME is not set"
    exit 1
fi

# Check signatures. If this fails, there's no point in attempting notarization.
pkgutil --check-signature "$INSTALLER_PATH"

# Submit for notarization to Apple servers
tmp_output_dir=$(mktemp -d)
json_output_file="${tmp_output_dir}/$(basename "$INSTALLER_PATH").notarization.json"
set +e
xcrun notarytool submit "$INSTALLER_PATH" \
    --apple-id "$APPLE_NOTARIZATION_USERNAME" \
    --password "$APPLE_NOTARIZATION_PASSWORD" \
    --team-id "$APPLE_NOTARIZATION_TEAM_ID" \
    --output-format json \
    --wait \
    --timeout 30m \
    | tee "$json_output_file"
notary_exit_code=$?
set -e
if [[ $notary_exit_code != 0 ]]; then
    submission_id=$(jq -r '.id' "$json_output_file")
    xcrun notarytool log "$submission_id" \
        --apple-id "$APPLE_NOTARIZATION_USERNAME" \
        --password "$APPLE_NOTARIZATION_PASSWORD" \
        --team-id "$APPLE_NOTARIZATION_TEAM_ID"
    exit $notary_exit_code
fi

# Staple
xcrun stapler staple --verbose "$INSTALLER_PATH"

# Check notarization status
spctl --assess -vv --type install "$INSTALLER_PATH" 2>&1 | tee /dev/stderr | grep accepted
