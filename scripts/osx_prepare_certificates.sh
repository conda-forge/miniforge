#!/usr/bin/env bash

set -euxo pipefail

# Import AppleID certificates on macOS
# This script is used to import the AppleID certificates into the keychain
# It expects the following environment variables to be set:
# - APPLE_INSTALLER_CERTIFICATE_BASE64: base64 encoded certificate
# - APPLE_INSTALLER_CERTIFICATE_PASSWORD: password for the certificate
# - APPLE_APPLICATION_CERTIFICATE_BASE64: base64 encoded certificate
# - APPLE_APPLIATION_CERTIFICATE_PASSWORD: password for the certificate
# - APPLE_NOTARIZATION_AUTHKEY_BASE64: base64 encoded AppStore Connect API authkey (.p8)
# - APPLE_TEMP_KEYCHAIN_PASSWORD: user-generated password for the temporary keychain
# Certificates can be generated at https://developer.apple.com/account/resources/certificates/list

# create variables
TEMP_DIR="$(mktemp -d)"
INSTALLER_CERTIFICATE_PATH="$TEMP_DIR/installer_developer_cert.p12"
APPLICATION_CERTIFICATE_PATH="$TEMP_DIR/application_developer_cert.p12"
NOTARIZATION_AUTHKEY_PATH="$TEMP_DIR/notarization_authkey.p8"
KEYCHAIN_PATH="$TEMP_DIR/installer-signing.keychain-db"

# import certificate and provisioning profile from secrets
echo -n "${APPLE_INSTALLER_CERTIFICATE_BASE64}" | base64 --decode --output "$INSTALLER_CERTIFICATE_PATH"
echo -n "${APPLE_APPLICATION_CERTIFICATE_BASE64}" | base64 --decode --output "$APPLICATION_CERTIFICATE_PATH"
echo -n "${APPLE_NOTARIZATION_AUTHKEY_BASE64}" | base64 --decode --output "$NOTARIZATION_AUTHKEY_PATH"

# create temporary keychain
security create-keychain -p "${APPLE_TEMP_KEYCHAIN_PASSWORD}" "$KEYCHAIN_PATH"
security set-keychain-settings -lut 21600 "$KEYCHAIN_PATH"
security unlock-keychain -p "${APPLE_TEMP_KEYCHAIN_PASSWORD}" "$KEYCHAIN_PATH"

# import certificate to keychain
security import "$INSTALLER_CERTIFICATE_PATH" -P "${APPLE_INSTALLER_CERTIFICATE_PASSWORD}" -A -t cert -f pkcs12 -k "$KEYCHAIN_PATH"
security import "$APPLICATION_CERTIFICATE_PATH" -P "${APPLE_INSTALLER_CERTIFICATE_PASSWORD}" -A -t cert -f pkcs12 -k "$KEYCHAIN_PATH"
security list-keychain -d user -s "$KEYCHAIN_PATH"

# export identity name to construct.yaml
APPLE_SIGNING_IDENTITY=$(security find-identity "$KEYCHAIN_PATH" | grep -m 1 -o '"Developer ID Installer.*"' | tr -d '"')
APPLE_NOTARIZATION_IDENTITY=$(security find-identity "$KEYCHAIN_PATH" | grep -m 1 -o '"Developer ID Application.*"' | tr -d '"')

export APPLE_SIGNING_IDENTITY
export APPLE_NOTARIZATION_IDENTITY
export APPLE_NOTARIZATION_AUTHKEY_PATH="$NOTARIZATION_AUTHKEY_PATH"
