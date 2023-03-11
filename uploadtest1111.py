#!/bin/bash
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

import requests

# Set up the API endpoint and authentication
api_endpoint = 'https://fixapc.net/wp-json/wp/v2/posts'
username = 'fixapc'
app_password = 'seYx bEdm kYg0 F53O m5kF dWat'
auth = requests.auth.HTTPBasicAuth(username, app_password)

# Set up the post data
post_data = {
    'title': 'My New Post2',
    'content': 'This is my new post content.',
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


