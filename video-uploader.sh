#!/bin/bash
set -x
black="\033[0;30m"
red="\033[0;31m"
green="\033[0;32m"
orange="\033[0;33m"
yellow="\033[0;33m"
blue="\033[0;34m"
purple="\033[0;35m"
cyan="\033[0;36m"
white="\033[0;37m"
nocolor="\033[0m"

export LIBVA_DRIVER_NAME=nvidia

#The user to launch chrome under
user=usr

#Your Saved Video Location
videosavelocation="/mnt/fixapc.net/mnt/nextcloud/fixapc/files/EVERYTHING/AUDIO_VIDEO/VIDEO_PRODUCTION/FIXAPC_TECH_CHANNEL"

#Testing
read -r -p "$(echo -e "$yellow Please Enter The Title Of The Video $nocolor")" title

#Testing
read -r -p "$(echo -e "$yellow Please Enter The Type Of Tutorial:$nocolor $green 1=Micro Tutorial $nocolor, $blue Full Tutorial=2 $nocolor, $red Quick Fix=3 $nocolor")" selecttuttype
if [ "$selecttuttype" = 1 ]; then
    typeoftutorial="video_cover_micro.png"
elif [ "$selecttuttype" = 2 ]; then
    typeoftutorial="video_cover_full.png"
elif [ "$selecttuttype" = 3 ]; then
    typeoftutorial="video_cover_fix.png"
else
    echo "Invalid Selection"
    exit
fi

#Start the image selector
python3 <<EOF
import os
import requests
import shutil
from bs4 import BeautifulSoup
from urllib.parse import urlparse
import subprocess

# set the search keywords
search_query = "gentoo logo"
file_type = "png"

# get the first word in the search query
query_words = search_query.split()
if len(query_words) > 0:
    first_word = query_words[0]
else:
    first_word = "image"

# set the number of images to download
num_images = 20

# set the directory to save the images
save_dir = "images"

# create the save directory if it doesn't exist
if not os.path.exists(save_dir):
    os.makedirs(save_dir)

# perform the Google search and download the images
url = f"https://www.google.com/search?q={search_query}&source=lnms&tbm=isch&tbs=imgo:1"
response = requests.get(url)

soup = BeautifulSoup(response.text, "html.parser")
image_links = soup.select("div.rg_i")

for i, img in enumerate(image_links[:num_images]):
    img_url = img.select_one("img.rg_i")["data-src"]
    parsed_url = urlparse(img_url)
    if not parsed_url.scheme:
        img_url = f"http:{img_url}"
    if not parsed_url.netloc:
        img_url = f"http://www.google.com{img_url}"
    filename = f"{first_word}_{i+1}.{file_type}"
    filepath = os.path.join(filename)

    try:
        response = requests.get(img_url, stream=True)
        with open(filepath, "wb") as out_file:
            shutil.copyfileobj(response.raw, out_file)
    except Exception as e:
        print(f"Failed to download {filename}: {e}")

# show a preview of the images using fzf
image_files = [f for f in os.listdir(
    save_dir) if os.path.isfile(os.path.join(f))]
image_files.sort()
fzf_command = f"fzf --preview 'feh {os.path.join('{}')}' --prompt='Select image: ' --ansi"
selected_file = subprocess.check_output(
    fzf_command, shell=True, text=True).strip()
if selected_file:
    # rename the selected file to "image.png"
    new_filepath = os.path.join("image.png")
    os.rename(os.path.join(selected_file), new_filepath)
    print(f"Renamed {selected_file} to image.png")
else:
    print("No image selected.")
EOF

#Create Title
titlefolder=$(echo -e "$title" | sed 's& &_&gI')
text="https://www.fixapc.net/$titlefolder"

#Start the wordpress poster script
python3 <<EOF
import requests

links = '''
    VIDEO TITLE - $title
    <a href="$text">WEBSITE LINK - $text</a>

    COMMUNITY LINKS
    <a href="https://www.fixapc.net">HOMEPAGE - https://www.fixapc.net</a>
    <a href="https://forum.fixapc.net">FORUMS - https://forum.fixapc.net</a>
    <a href="https://www.facebook.com/Fixapcdotnet">FACEBOOK - https://www.facebook.com/Fixapcdotnet</a>
    <a href="https://twitter.com/FIXAPCdotnet">TWITTER - https://twitter.com/FIXAPCdotnet</a>
    <a href="https://www.twitch.tv/fixapcdotnet">TWITCH - https://www.twitch.tv/fixapcdotnet</a>
    <a href="https://www.youtube.com/channel/UCSvBW8e2zGNFiSUSD9qLNbQ">YOUTUBE - https://www.youtube.com/channel/UCSvBW8e2zGNFiSUSD9qLNbQ</a>
    <a href="https://odysee.com/@fixapc">ODYSEE - https://odysee.com/@fixapc</a>
    <a href="https://www.tiktok.com/@fixapc">TIKTOK - https://www.tiktok.com/@fixapc</a>
    <a href="https://d.tube/#!/c/fixapc777">DTUBE - https://d.tube/#!/c/fixapc777</a>
    <a href="https://vimeo.com/user151963004">VIMEO - https://vimeo.com/user151963004</a>
    <a href="https://discord.gg/fwaJ9V8c">DISCORD - https://discord.gg/fwaJ9V8c</a>
    <a href="https://www.patreon.com/">PATREON - https://www.patreon.com/</a>

    TUTORIAL REQUESTS
    <a href="https://fixapc.net/tutorial-request/">REQUEST A TUTORIAL - https://fixapc.net/tutorial-request</a>

    SUPPORT LINKS
    <a href="https://paypal.me/FIXAPC">PAYPAL - https://paypal.me/FIXAPC</a>
    <a href="https://cash.app/fixapc/Patreon">CASHAPP - https://cash.app/fixapc/Patreon</a>
    <a href="https://fixapc.net/support-us/Patreon">PATREON - https://fixapc.net/support-us/Patreon</a>
'''

# Set up the API endpoint and authentication
api_endpoint = 'https://fixapc.net/wp-json/wp/v2/posts'
username = 'fixapc'
app_password = 'seYx bEdm kYg0 F53O m5kF dWat'
auth = requests.auth.HTTPBasicAuth(username, app_password)

# Set up the post data
post_data = {
    'title': '$title',
    'content': str(links),
    'status': 'publish'
}

# Upload the image to the media library
image_file = {'file': open('video_cover_fix.png', 'rb')}
response = requests.post('https://fixapc.net/wp-json/wp/v2/media', files=image_file, auth=auth)
if response.status_code == 201:
    media_id = response.json()['id']
    print('Image uploaded successfully!')
else:
    print('Error uploading image. Status code:', response.status_code)

# Set the featured image for the post
post_data['featured_media'] = media_id

# Make the API request to create the post
response = requests.post(api_endpoint, json=post_data, auth=auth)

# Check the response status code
if response.status_code == 201:
    print('Post created successfully!')
else:
    print('Error creating post. Status code:', response.status_code)
EOF

sudo -u $user mkdir "$videosavelocation/$titlefolder"

#Create News Banner
convert news_banner_ai.png -fill white -stroke black \
-pointsize 32 -font URWGothic-Demi -draw 'text 190,65 "'"$title"'"' \
-pointsize 20 -font URWGothic-Demi -draw 'text 220,100 "'"$text"'"' news_banner.png

#copy news banner to the newly created folder
sudo -u $user cp -a -r -f -v news_banner.png "$videosavelocation/$titlefolder"

#Delete news banner
sudo rm news_banner.png

#Create Video Cover
convert $typeoftutorial -fill white -stroke black \
-pointsize 60 -font URWGothic-Demi -gravity center -annotate +0+395 "$title" video_cover.png

#add image overlay to gentoo
composite -gravity center image.png video_cover.png

#copy video cover to the newly created folder
sudo -u $user cp -a -r -f -v video_cover.png "$videosavelocation/$titlefolder" 

#Delete Video Cover
sudo rm video_cover.png

#Copy Outro And Intro Clip To The Newly Created Folder
sudo -u $user cp -a -r -f -v "$videosavelocation/inclip.mp4"   "$videosavelocation/$titlefolder"
sudo -u $user cp -a -r -f -v "$videosavelocation/outclip.mp4"   "$videosavelocation/$titlefolder"

#start obs and wait for close
sudo -u $user easyeffects
sudo -u $user pavucontrol
sudo -u $user obs
for pid in $(pidof easyeffects); do sudo chrt -f -p 1 "$pid"; done; for pid in $(pidof easyeffects); do sudo chrt -p "$pid"; done;
for pid in $(pidof pipewire); do sudo chrt -f -p 1 "$pid"; done; for pid in $(pidof pipewire); do sudo chrt -p "$pid"; done;
for pid in $(pidof pipewire-pulse); do sudo chrt -f -p 1 "$pid"; done; for pid in $(pidof pipewire-pulse); do sudo chrt -p "$pid"; done;
for pid in $(pidof pavucontrol); do sudo chrt -f -p 1 "$pid"; done; for pid in $(pidof pavucontrol); do sudo chrt -p "$pid"; done;
for pid in $(pidof obs); do sudo chrt -f -p 1 "$pid"; done; for pid in $(pidof obs); do sudo chrt -p "$pid"; done;
for pid in $(pidof ssh); do sudo chrt -f -p 1 "$pid"; done; for pid in $(pidof ssh); do sudo chrt -p "$pid"; done;
for pid in $(pidof virt-manager); do sudo chrt -f -p 1 "$pid"; done; for pid in $(pidof virt-manager); do sudo chrt -p "$pid"; done;

#
read -r -p "$(echo -e "$yellow Start The Video Uploads:$nocolor $green Y/y=YES $nocolor, $red N/n=NO $nocolor")" startupload
if [[ $startupload = Y ]] || [[ $startupload = y ]]; then
echo enter upload script here
else exit
fi