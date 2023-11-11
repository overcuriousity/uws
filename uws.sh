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
echo "Starting download..."
# Log wget output for troubleshooting
WGET_LOG_FILE="${TMP_DIR}/wget.log"
if ! wget --recursive --level="$DEPTH" --html-extension --convert-links --no-parent --reject=jpg,jpeg,png,gif --continue --directory-prefix="$TMP_DIR" "$URL" > "$WGET_LOG_FILE" 2>&1; then
    echo "Warning: There were issues downloading some parts of the website. Check $WGET_LOG_FILE for details."
else
    echo "Download completed successfully."
fi

mkdir -p "$OUTPUT_DIR"
find "$TMP_DIR" -type f -name "*.html" | while read -r file; do
    # Remove HTML tags and decode HTML entities
    sed -e 's/<[^>]*>//g' "$file" | html2text >> "$FINAL_OUTPUT_FILE"
done
rm -rf "$TMP_DIR"
echo "Operation done."
exit 1


