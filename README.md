# Uncomplicated Website Scraper (uws)

This script is designed to download web pages from a specified URL and convert them to plain text. It's particularly useful for creating a text-based dataset from a website for various purposes like data analysis, machine learning, or personal archiving.

## Features

- Downloads entire website or specific pages up to a defined depth.
- Converts HTML content to plain text.
- Excludes image files (jpg, jpeg, png, gif) during the download process.
- By default, consolidates all text content into a single file.

## Prerequisites

Before you run this script, ensure you have the following installed:
- wget: For downloading web pages.
- lynx: For converting HTML to plain text.

For Manjaro/Arch-based systems, install them using:
sudo pacman -S wget lynx

For Debian-based systems (like Ubuntu), use:
sudo apt-get install wget lynx

## Usage

1. Clone the repository or download the script.
2. Make the script executable:
   chmod +x uws.sh
3. Run the script with the desired URL and optional file size parameter:
   ./uws.sh <URL> [FILE_SIZE] [DEPTH]
   Example:
   ./uws.sh http://example.com -10M 1

## Disclaimer

This script is for educational and research purposes only. Ensure you have the right to download and process the content from the specified URL. Respect robots.txt files and website terms of service. The author is not responsible for any misuse of this tool or any violations of data use policies.

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to check issues page if you want to contribute.

## License

Distributed under the GNU License. See LICENSE for more information.


