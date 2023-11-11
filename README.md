# uws
Uncomplicated Website Scraper

This script is designed to download web pages from a specified URL, convert them to plain text, and then split the text into multiple files of a specified size. It's particularly useful for creating a text-based dataset from a website for various purposes like data analysis, machine learning, or personal archiving.

# Features

- Downloads entire website or specific pages.
- Converts HTML content to plain text using lynx.
- Splits the text content into files of specified size.
- Stores temporary data in RAM for efficiency.

# Prerequisites

Before you run this script, ensure you have the following installed:
- wget: For downloading web pages.
- lynx: For converting HTML to plain text.

For Manjaro/Arch-based systems, install them using:
sudo pacman -S wget lynx

For Debian-based systems (like Ubuntu), use:
sudo apt-get install wget lynx

# Usage

1. Clone the repository or download the script.
2. Make the script executable:
   chmod +x web_scraper_to_text_split.sh
3. Run the script with the desired URL and optional file size parameter:
   ./web_scraper_to_text_split.sh <URL> [FILE_SIZE]
   Example:
   ./web_scraper_to_text_split.sh http://example.com -10M

# Disclaimer

This script is for educational and research purposes only. Ensure you have the right to download and process the content from the specified URL. Respect robots.txt files and website terms of service. The author is not responsible for any misuse of this tool or any violations of data use policies.

# Contributing

Contributions, issues, and feature requests are welcome. Feel free to check issues page (your-issue-link-here) if you want to contribute.

# License

Distributed under the GNU License. See LICENSE for more information.


