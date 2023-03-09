#!/bin/bash

#Your Saved Video Location
title=herewego
videosavelocation="/mnt/fixapc.net/mnt/nextcloud/fixapc/files/EVERYTHING/AUDIO VIDEO/VIDEO_PRODUCTION/FIXAPC_TECH_CHANNEL"
file_path="$videosavelocation"/"$titlefolder"
mkdir "$videosavelocation" "$titlefolder"

TOKEN_FILE="token"

# Get access token
ACCESS_TOKEN=$(python3 -c "import pickle; import os; credentials = None; 
if os.path.exists('$TOKEN_FILE'): 
    with open('$TOKEN_FILE', 'rb') as f: 
        credentials = pickle.load(f); 
if credentials: 
    print(credentials.token)")

# Define variables
CLIENT_ID="847826704620-k2c2ppi3vckga683n6g3pljlsck7gff8.apps.googleusercontent.com"
CLIENT_SECRET="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"
VIDEO_TITLE="test"
VIDEO_DESCRIPTION="test"
VIDEO_TAGS="test"

# Upload video
curl \
  --request POST \
  --header "Authorization: Bearer ${ACCESS_TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{\"snippet\":{\"title\":\"${VIDEO_TITLE}\",\"description\":\"${VIDEO_DESCRIPTION}\",\"tags\":[${VIDEO_TAGS}]}}" \
  --data-binary "@${file_path}" \
  https://www.googleapis.com/upload/youtube/v3/videos?uploadType=resumable
