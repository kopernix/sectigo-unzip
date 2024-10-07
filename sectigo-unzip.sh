#!/bin/bash

# MIT License
# Copyright (c) 2024 JPA Kopernix
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, subject to the following conditions.

# Description: This script unzips a specified ZIP file containing SSL certificates,
# cleans the CA bundle by removing the second certificate, and concatenates the
# main certificate with the cleaned CA bundle. The final certificate is saved as
# crucerosmediterraneo.com.crt.

# Check if a ZIP file is provided as an argument
if [[ -z "$1" ]]; then
  echo "Usage: $0 <zip_file> [options]"
  echo "Options:"
  echo "  --nodel          Keep the temporary directory after execution."
  echo "  -s, --simple     Extract the cleaned CA bundle and the certificate without combining."
  exit 1
fi

ZIP_FILE="$1"

# Option to keep the temporary directory
KEEP_TEMP=false
SIMPLE=false

# Parse all options
shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --nodel)
      KEEP_TEMP=true
      ;;
    -s|--simple)
      SIMPLE=true
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

# Temporary directory for unzipping files
TMP_DIR="cert_tmp"

# Unzip the ZIP file with error handling
if ! unzip -o "$ZIP_FILE" -d "$TMP_DIR"; then
  echo "Error: Failed to unzip the file."
  exit 1
fi

# Find the relevant files in the unzipped structure
CRT_FILE=$(find "$TMP_DIR" -name "*.crt" | head -n 1)
CA_BUNDLE=$(find "$TMP_DIR" -name "*.ca-bundle" | head -n 1)

# Verify if the required files are found
if [[ -z "$CRT_FILE" || -z "$CA_BUNDLE" ]]; then
  echo "Error: Required .crt or ca-bundle files not found."
  exit 1
fi

# Save a copy of the original ca-bundle
cp "$CA_BUNDLE" "$TMP_DIR/ca-bundle-original.crt"

# Remove the second certificate from the ca-bundle
awk 'BEGIN {found = 0} \
     /BEGIN CERTIFICATE/ {found++} \
     found <= 1 {print}' "$CA_BUNDLE" > "$TMP_DIR/ca-bundle-cleaned.crt"

if [ "$SIMPLE" = true ]; then
  # If simple mode, extract cleaned ca-bundle and crt without combining
  CLEANED_BUNDLE="$(basename "$CA_BUNDLE" .ca-bundle).ca-bundle"
  cp "$TMP_DIR/ca-bundle-cleaned.crt" "$CLEANED_BUNDLE"
  cp "$CRT_FILE" .
  echo "The cleaned CA bundle has been saved as '$CLEANED_BUNDLE' and the certificate as '$(basename "$CRT_FILE")'"
else
  # Overwrite the original ca-bundle with the cleaned one
  cp "$TMP_DIR/ca-bundle-cleaned.crt" "$CA_BUNDLE"

  # Concatenate the .crt file with the cleaned ca-bundle
  FINAL_CERT="$(basename "$CRT_FILE" .crt).crt"
  cat "$CRT_FILE" <(echo) "$CA_BUNDLE" > "$FINAL_CERT"

  echo "The combined certificate has been created as '$FINAL_CERT'"
fi

# Remove the temporary directory unless --nodel is specified
if [ "$KEEP_TEMP" = false ]; then
  rm -r "$TMP_DIR"
fi
