import json
import requests

# Set the URL of the LBRY API endpoint
api_url = 'http://localhost:5279'

# Set the path to the video file to be uploaded
video_path = '/mnt/fixapc.netnextcloud/fixapc/files/EVERYTHING/AUDIO VIDEO/VIDEO_PRODUCTION/completed.mp4'

# Set the desired name and title of the video
video_name = 'test'
video_title = 'Test'

# Make a call to the LBRY API to upload the video
response = requests.post(api_url, json={
    'method': 'publish',
    'params': {
        'name': video_name,
        'title': video_title,
        'file_path': video_path
    }
})

# Print the response from the LBRY API
print(json.dumps(response.json(), indent=4))