#!/bin/bash

# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null
}

# Check for required commands
if ! command_exists wget || ! command_exists cat; then
    echo "Error: This script requires 'wget' and 'cat'. Please install them to continue."
    exit 1
fi

# Check if URL is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <URL> [DEPTH]"
    exit 1
fi

URL="$1"
TMP_DIR="/dev/shm/website_data"
OUTPUT_DIR="final_output"
FINAL_OUTPUT_FILE="${OUTPUT_DIR}/final_text_output.txt"

# Optional depth parameter for scraping
DEPTH=${2:-"inf"}  # Set to "inf" (infinite) if not specified

# Check write permission for /dev/shm and output directory
if ! [ -w "/dev/shm" ] || ( [ ! -d "$OUTPUT_DIR" ] && ! mkdir -p "$OUTPUT_DIR" ) || ! [ -w "$OUTPUT_DIR" ]; then
    echo "Error: The script does not have permission to write to required directories."
    exit 1
fi

# Create a directory in /dev/shm for temporary storage
mkdir -p "$TMP_DIR"

# Download the website with specified depth, excluding images
if ! wget --recursive --level="$DEPTH" --html-extension --convert-links --no-parent --reject=jpg,jpeg,png,gif --directory-prefix="$TMP_DIR" --spider "$URL"; then
    echo "Error: Failed to estimate the size of the website. Check the URL and network connection."
    exit 1
fi

# Estimate the size of the downloaded content
echo "Estimating the size of downloaded content..."
SIZE=$(du -sh "$TMP_DIR" | cut -f1)
echo "Estimated size of the content is $SIZE."

# Ask user to continue or abort
read -p "Do you want to continue and save the content? (Y/n, press Enter for Yes) " choice
case "$choice" in
  Y|y|"")
    echo "Continuing with download..."
    if ! wget --recursive --level="$DEPTH" --html-extension --convert-links --no-parent --reject=jpg,jpeg,png,gif --directory-prefix="$TMP_DIR" "$URL"; then
        echo "Error: Failed to download the website. Check the URL and network connection."
        exit 1
    fi
    mkdir -p "$OUTPUT_DIR"
    find "$TMP_DIR" -type f -name "*.html" -exec cat {} + > "$FINAL_OUTPUT_FILE"
    echo "Content has been saved into $FINAL_OUTPUT_FILE"
    rm -rf "$TMP_DIR"
    ;;
  *)
    echo "Operation aborted."
    rm -rf "$TMP_DIR"
    exit 1
    ;;
esac
