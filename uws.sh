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
ROOT_DOMAIN=$(echo "$URL" | awk -F/ '{print $3}' | sed 's/[.\/]/_/g')
DEPTH=${2:-"inf"}  # Set to "inf" (infinite) if not specified
FILE_SIZE=${3:-"10M"}  # Default to 10M if not specified

# Check write permission for /dev/shm and output directory
if ! [ -w "/dev/shm" ] || ( [ ! -d "$OUTPUT_DIR" ] && ! mkdir -p "$OUTPUT_DIR" ) || ! [ -w "$OUTPUT_DIR" ]; then
    echo "Error: The script does not have permission to write to required directories."
    exit 1
fi

# Create a directory in /dev/shm for temporary storage
mkdir -p "$TMP_DIR"

# Download the website with specified depth, excluding images
echo "Starting download..."
wget --recursive --level="$DEPTH" --html-extension --convert-links --no-parent --reject=jpg,jpeg,png,gif --continue --directory-prefix="$TMP_DIR" "$URL"
WGET_EXIT_STATUS=$?

if [ $WGET_EXIT_STATUS -ne 0 ]; then
    echo "Warning: There were some issues during download. Some content might be missing."
fi

echo "Processing downloaded files..."
mkdir -p "$OUTPUT_DIR"
FINAL_INTERMEDIATE_FILE="/dev/shm/final_intermediate.txt"

# Concatenate all text into one intermediate file
find "$TMP_DIR" -type f -name "*.html" | while read -r file; do
    echo "Processing file: $file"
    html2text "$file" >> "$FINAL_INTERMEDIATE_FILE"
done

# Split the final output into multiple files using the root domain in the file name
split -b "$FILE_SIZE" -d -a 4 "$FINAL_INTERMEDIATE_FILE" "${OUTPUT_DIR}/${ROOT_DOMAIN}_"

echo "Content has been split and saved into $OUTPUT_DIR"
rm -rf "$TMP_DIR" "$FINAL_INTERMEDIATE_FILE"
echo "Operation done."

exit 0
