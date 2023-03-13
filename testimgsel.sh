#!/bin/bash

# import necessary packages
# not required for Bash
# os, requests, shutil, BeautifulSoup, urlparse, and subprocess are not built-in Bash commands
# and must be installed separately
# for example, on Debian-based systems, you can run:
# sudo apt-get install -y python3-requests python3-bs4 fzf feh
# or use your system's package manager
# note that Python 3.x and fzf are required
# this script assumes that these packages are already installed
# otherwise, you will need to install them before running the script
# or add a check for their existence and installation commands

# set the search keywords
search_query="gentoo logo"
file_type="png"

# get the first word in the search query
first_word=$(echo "$search_query" | awk '{print $1}')

# set the number of images to download
num_images=20

# set the directory to save the images
save_dir="images"

# create the save directory if it doesn't exist
mkdir -p "$save_dir"

# perform the Google search and download the images
url="https://www.google.com/search?q=${search_query}&source=lnms&tbm=isch&tbs=imgo:1"
response=$(curl -s "$url")

image_links=$(echo "$response" | grep -Eo '<div class="rg_i"[^>]+>')
i=1
for img in $image_links; do
    img_url=$(echo "$img" | grep -Eo 'data-src="[^"]+"|data-srcset="[^"]+"' | head -n 1 | sed -E 's/^data-src(set)?=//' | tr -d '"' | sed 's/ &.*$//')
    parsed_url=$(echo "$img_url" | awk -F/ '{print $1}')
    if [[ -z "$parsed_url" ]]; then
        img_url="http:$img_url"
    elif [[ "$parsed_url" != "http:" && "$parsed_url" != "https:" ]]; then
        img_url="http://www.google.com$img_url"
    fi
    filename="${first_word}_${i}.${file_type}"
    filepath="$save_dir/$filename"

    # download the image
    curl -s -L -o "$filepath" "$img_url"

    if [[ $? -ne 0 ]]; then
        echo "Failed to download $filename"
    fi

    ((i++))
    if [[ $i -gt $num_images ]]; then
        break
    fi
done

# show a preview of the images using fzf
image_files=("$save_dir"/*)
if [[ -n "$image_files" ]]; then
    selected_file=$(printf '%s\n' "${image_files[@]}" | fzf --preview "feh {}" --prompt="Select image: " --ansi)
    if [[ -n "$selected_file" ]]; then
        # rename the selected file to "image.png"
        new_filepath="$save_dir/image.png"
        mv "$selected_file" "$new_filepath"
        echo "Renamed $selected_file to image.png"
    else
        echo "No image selected."
    fi
else
    echo "No images found in $save_dir"
fi
