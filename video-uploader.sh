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
supportlinks='
Platform - Links
Homepage - https://www.fixapc.net
Forum    - https://forum.fixapc.net
Facebook - https://www.facebook.com/Fixapcdotnet
Twitter  - https://twitter.com/FIXAPCdotnet
Twitch   - https://www.twitch.tv/fixapcdotnet
Youtube  - https://www.youtube.com/channel/UCSvBW8e2zGNFiSUSD9qLNbQ
Odysee   - https://odysee.com/@Fixapc:5
Tiktok   - https://www.tiktok.com/@fixapc
Dtube    - https://d.tube/#!/c/fixapc777
Vimeo    - https://vimeo.com/user151963004

Communication Links
Discord  - https://discord.gg/fwaJ9V8c

Support US If you would like to me more content and tutorials.
Supporters have tutorial request priority
Patreon  - https://www.patreon.com/
Paypal   - https://paypal.me/FIXAPC/
Cashapp  - https://cash.app/$fixapc/

For a full range of support options including crypto.
https://fixapc.net/support-us/

Request a tutorial
https://fixapc.net/tutorial-request/

Website based version
https://fixapc.net/'$title'/'

#Create News Banner
convert news_banner_ai.png -fill white -stroke black \
-pointsize 32 -font URWGothic-Demi -draw 'text 190,65 "'"$title"'"' \
-pointsize 20 -font URWGothic-Demi -draw 'text 220,100 "'"$text"'"' \
news_banner.png
sudo -u $user cp -a -r -f -v news_banner.png "$videosavelocation"/
sudo -u $user cp -a -r -f -v news_banner.png "$videosavelocation"/"$titlefolder"
rm news_banner.png

#Create Video Cover
convert $typeoftutorial -fill white -stroke black \
-pointsize 60 -font URWGothic-Demi -gravity center -annotate +0+395 "$title" \
video_cover.png \
sudo -u $user cp -a -r -f -v video_cover.png "$videosavelocation" \
sudo -u $user cp -a -r -f -v video_cover.png "$videosavelocation"/"$titlefolder"

#add image overlay to gentoo
video_cover_pre.png
composite -gravity center image.png video_cover.png
sudo -u $user cp -a -r -f -v video_cover.png "$videosavelocation"/"$titlefolder"
sudo rm video_cover.png

#Copy Outro And Intro Clip To The Newly Created Folder
sudo -u $user cp -a -r -f -v "$videosavelocation"/inclip.mp4    "$videosavelocation"/"$titlefolder"
sudo -u $user cp -a -r -f -v "$videosavelocation"/outclip.mp4   "$videosavelocation"/"$titlefolder"

python <<EOF
import os
import pickle
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

# Define the scope of the YouTube API
SCOPES = ["https://www.googleapis.com/auth/youtube.upload"]

# Set the title and description of the video
title = "My Awesome Video"
description = "Check out my awesome video! \n\n" + supportlinks

# Authenticate and build the YouTube API client
creds = None
if os.path.exists("token.pickle"):
    with open("token.pickle", "rb") as token:
        creds = pickle.load(token)
if not creds or not creds.valid:
    if creds and creds.expired and creds.refresh_token:
        creds.refresh(Request())
    else:
        flow = InstalledAppFlow.from_client_secrets_file(
            "client_secrets.json", SCOPES)
        creds = flow.run_local_server(port=0)
    with open("token.pickle", "wb") as token:
        pickle.dump(creds, token)

youtube = build("youtube", "v3", credentials=creds)

# Set the video metadata
body = {
    "snippet": {
        "title": title,
        "description": description,
        "tags": ["tag1", "tag2"]
    },
    "status": {
        "privacyStatus": "public"
    }
}

# Define the video file path
file_path = "$videosavelocation"/"$titlefolder"

try:
    # Upload the video
    videos_insert_response = youtube.videos().insert(
        part=",".join(body.keys()),
        body=body,
        media_body=MediaFileUpload(file_path, chunksize=-1, resumable=True)
    ).execute()

    print("Video uploaded successfully!")
    print("Video ID: " + videos_insert_response["id"])
except HttpError as e:
    print("An HTTP error %d occurred:\n%s" % (e.resp.status, e.content))t))
EOF

#start obs and wait for close
sudo -u $user easyeffects
sudo -u $user pavucontrol
sudo -u $user LIBVA_DRIVER_NAME=nvidia obs
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

