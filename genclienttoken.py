#!/bin/bash

# Set the client ID and secret as environment variables
export CLIENT_ID="847826704620-k2c2ppi3vckga683n6g3pljlsck7gff8.apps.googleusercontent.com"
export CLIENT_SECRET="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"

# Make a request to the YouTube API to get an access token
response=$(curl --request POST \
  --url 'https://accounts.google.com/o/oauth2/token' \
  --header 'content-type: application/x-www-form-urlencoded' \
  --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&grant_type=client_credentials&scope=https://www.googleapis.com/auth/youtube.force-ssl")

# Extract the access token from the response
access_token=$(echo $response | jq -r '.access_token')

# Print the access token
echo -e "Access token: $access_token"