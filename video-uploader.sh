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

#Set the cover image
python3 addcoverimg.py

#The user to launch chrome under
user=usr

#Your Saved Video Location
videosavelocation="/mnt/fixapc.net/mnt/nextcloud/fixapc/files/EVERYTHING/AUDIO VIDEO/VIDEO_PRODUCTION/FIXAPC_TECH_CHANNEL"

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

#Create Title
titlefolder=$(echo -e "$title" | sed 's& &_&gI')
sudo -u $user mkdir "$videosavelocation"/"$titlefolder"
text="https://www.fixapc.net/$titlefolder"
#Create Support Links
#supportlinks=''
#Platform - Links
#Homepage - https://www.fixapc.net
#Forum    - https://forum.fixapc.net
#Facebook - https://www.facebook.com/Fixapcdotnet
#Twitter  - https://twitter.com/FIXAPCdotnet
#Twitch   - https://www.twitch.tv/fixapcdotnet
#Youtube  - https://www.youtube.com/channel/UCSvBW8e2zGNFiSUSD9qLNbQ
#Odysee   - https://odysee.com/@Fixapc:5
#Tiktok   - https://www.tiktok.com/@fixapc
#Dtube    - https://d.tube/#!/c/fixapc777
#Vimeo    - https://vimeo.com/user151963004
#
#Communication Links
#Discord  - https://discord.gg/fwaJ9V8c
#
#Support US If you would like to me more content and tutorials.
#Supporters have tutorial request priority
#Patreon  - https://www.patreon.com/
#Paypal   - https://paypal.me/FIXAPC/
#Cashapp  - https://cash.app/$fixapc/
#
#For a full range of support options including crypto.
#https://fixapc.net/support-us/
#
#Request a tutorial
#https://fixapc.net/tutorial-request/
#
#Website based version
#https://fixapc.net/'$title'/'

#
python3 <<EOF
import requests

links = {
    homepage: https://www.fixapc.net,
    forum: https://forum.fixapc.net,
    facebook: https://www.facebook.com/Fixapcdotnet,
    twitter: https://twitter.com/FIXAPCdotnet,
    twitch: https://www.twitch.tv/fixapcdotnet,
    youtube: https://www.youtube.com/channel/UCSvBW8e2zGNFiSUSD9qLNbQ,
    odysee: https://odysee.com/@Fixapc:5,
    tiktok: https://www.tiktok.com/@fixapc,
    dtube: https://d.tube/#!/c/fixapc777,
    vimeo: https://vimeo.com/user151963004,
    discord: https://discord.gg/fwaJ9V8c,
    patreon: https://www.patreon.com/,
    paypal: https://paypal.me/FIXAPC/,
    cashapp: https://cash.app/fixapc/,
    tutorial_request: https://fixapc.net/tutorial-request/,
    support_us: https://fixapc.net/support-us/
}

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

#Create News Banner
convert news_banner_ai.png -fill white -stroke black \
-pointsize 32 -font URWGothic-Demi -draw 'text 190,65 "'"$title"'"' \
-pointsize 20 -font URWGothic-Demi -draw 'text 220,100 "'"$text"'"' news_banner.png

#copy news banner to the newly created folder
sudo -u $user cp -a -r -f -v news_banner.png "$videosavelocation"/"$titlefolder"

#Delete news banner
sudo rm news_banner.png

#Create Video Cover
convert $typeoftutorial -fill white -stroke black \
-pointsize 60 -font URWGothic-Demi -gravity center -annotate +0+395 "$title" video_cover.png

#copy video cover to the newly created folder
sudo -u $user cp -a -r -f -v video_cover.png "$videosavelocation"/"$titlefolder" 

#add image overlay to gentoo
composite -gravity center image.png video_cover.png

#copy video cover to the newly created folder
sudo -u $user cp -a -r -f -v video_cover.png "$videosavelocation"/"$titlefolder" 

#Delete Video Cover
sudo rm video_cover.png

#Copy Outro And Intro Clip To The Newly Created Folder
sudo -u $user cp -a -r -f -v "$videosavelocation"/inclip.mp4    "$videosavelocation"/"$titlefolder"
sudo -u $user cp -a -r -f -v "$videosavelocation"/outclip.mp4   "$videosavelocation"/"$titlefolder"

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