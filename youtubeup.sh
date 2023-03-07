#!/bin/bash
file_path="$videosavelocation"/"$titlefolder"
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

python3 <<EOF
import os
import pickle
import google.auth.transport.requests
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from googleapiclient.http import MediaFileUpload

# Define the scope of the YouTube API
SCOPES = ["https://www.googleapis.com/auth/youtube.upload"]

# Set the title and description of the video
title = ""
description = "Check out my awesome video!"

# Authenticate and build the YouTube API client
creds = None
if os.path.exists("token.pickle"):
    with open("token.pickle", "rb") as token:
        creds = pickle.load(token)
if not creds or not creds.valid:
    if creds and creds.expired and creds.refresh_token:
        creds.refresh(google.auth.transport.requests.Request())
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
file_path="$file_path"

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
    print("An HTTP error %d occurred:\n%s" % (e.resp.status, e.content))
EOF