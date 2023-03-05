#!/bin/bash

# Prompt the user to enter a file type
read -p "Enter the file type (e.g. jpg, png, gif): " file_type

# Prompt the user to enter keywords
read -p "Enter the keywords for the search: " keywords

# Generate the search URL
search_url="https://www.google.com/search?q=$imgtosearch%20&tbm=isch&tbs=ift:png"
https://www.google.com/search?q=gentoo%20logo&tbm=isch&tbs=ift:png
# Download the search results page using wget
wget -q -O - "${search_url}" \
| sed 's/</\n</g' \
| grep -Eo '<img[^>]*src="[^"]*"' \
| sed 's/<img[^>]*src="//g' \
| sed 's/"$//' \
| xargs -n1 wget -q