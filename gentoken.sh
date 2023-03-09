#!/bin/bash
set -x

# Set the client ID and secret as environment variables
export CLIENT_ID="847826704620-k2c2ppi3vckga683n6g3pljlsck7gff8.apps.googleusercontent.com"
export CLIENT_SECRET="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"

# Set the redirect URI for the web application
export REDIRECT_URI="http://localhost:0/oauth2callback"

# Build the authorization URL
AUTH_URL="https://accounts.google.com/o/oauth2/v2/auth"
AUTH_URL+="?client_id=${CLIENT_ID}"
AUTH_URL+="&response_type=code"
AUTH_URL+="&redirect_uri=${REDIRECT_URI}"
AUTH_URL+="&scope=https://www.googleapis.com/auth/youtube.readonly"

# Open the authorization URL in Google Chrome
google-chrome "${AUTH_URL}"

# Wait for the user to authorize the application and obtain the authorization code
echo "Please enter the authorization code:"
read AUTH_CODE

# Exchange the authorization code for an access token
response=$(curl --request POST \
  --url 'https://oauth2.googleapis.com/token' \
  --header 'content-type: application/x-www-form-urlencoded' \
  --data "client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&code=${AUTH_CODE}&grant_type=authorization_code&redirect_uri=${REDIRECT_URI}")

# Extract the access token from the response
access_token=$(echo -e "$response" | jq -r '.access_token')

# Print the access token
echo "Access token: ${access_token}"
