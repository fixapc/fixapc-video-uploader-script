#!/root/anaconda3/bin/python3
import os
import pickle
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from googleapiclient.http import MediaFileUpload


# Define the scope of the YouTube API
SCOPES = ["https://www.googleapis.com/auth/youtube.upload"]

# Set the title and description of the video
title = "My Awesome Video"
description = "Check out my awesome video!"

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
file_path = "${htmlimgheader[i]}"

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
