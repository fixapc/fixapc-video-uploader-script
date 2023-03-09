curl \
  --request POST \
  --data "client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>&code=<AUTHORIZATION_CODE>&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" \
  https://oauth2.googleapis.com/token