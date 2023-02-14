#!/usr/bin/python3
import os
import google.auth
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from google.oauth2.credentials import Credentials

# Set video file path
video_path = '/mnt/fixapc.netnextcloud/fixapc/files/EVERYTHING/AUDIO VIDEO/VIDEO_PRODUCTION/completed.mp4'

# Set video metadata
video_title = 'INSERT_VIDEO_TITLE_HERE'
video_description = 'INSERT_VIDEO_DESCRIPTION_HERE'
video_category = 'Tech'

# Set timecode template
timecode_template = '''0:00 - Description 1
0:15 - Description 2
0:30 - Video Start 
1:00 - Description 4
5:00 - Description 5
15:00 - Description 6
20:00 - Description 7
25:00 - Description 8
30:00 - Description 9'''

# Set API client
creds = None
if os.path.exists('token.json'):
    creds = Credentials.from_authorized_user_file('token.json', scopes=['https://www.googleapis.com/auth/youtube.upload'])
if not creds or not creds.valid:
    if creds and creds.expired and creds.refresh_token:
        creds.refresh(Request())
    else:
        flow = InstalledAppFlow.from_client_secrets_file(
            'client_secret.json',
            scopes=['https://www.googleapis.com/auth/youtube.upload']
        )
        creds = flow.run_local_server(port=0)
    with open('token.json', 'w') as token:
        token.write(creds.to_json())

youtube = build('youtube', 'v3', credentials=creds)

# Get channel ID
channels_response = youtube.channels().list(
    part='snippet',
    mine=True
).execute()
channel_id = channels_response['items'][0]['id']

# Create video resource
video = {
    'snippet': {
        'title': video_title,
        'description': video_description,
        'categoryId': video_category
    },
    'status': {
        'privacyStatus': 'private'
    }
}

# Upload video
try:
    insert_request = youtube.videos().insert(
        part='snippet,status',
        body=video,
        media_body=MediaFileUpload(video_path)
    )
    response = insert_request.execute()
    video_id = response['id']
except HttpError as e:
    print('An error occurred: %s' % e)
    video_id = None

# Add timecode template to video description
if video_id:
    video_resource = youtube.videos().list(
        part='snippet',
        id=video_id
    ).execute()
    video_description += '\n\nTimecode:\n' + timecode_template
    video_resource['items'][0]['snippet']['description'] = video_description
    update_request = youtube.videos().update(
        part='snippet',
        body=video_resource['items'][0]
    )
    update_request.execute()
    
# Print video URL
if video_id:
    print('Video uploaded: https://www.youtube.com/watch?v=' + video_id)
else:
    print('Video upload failed.')
