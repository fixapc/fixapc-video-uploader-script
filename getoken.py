#!/usr/bin/python3
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow

# Set OAuth2 credentials
CLIENT_ID = '847826704620-i30bp4u68p8hurvchhk5j8agb9jrdgdf.apps.googleusercontent.com'
CLIENT_SECRET = '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'
SCOPE = ['https://www.googleapis.com/auth/youtube.upload']

# Create OAuth2 flow
flow = InstalledAppFlow.from_client_config({
    'installed': {
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
        'redirect_uris': ['urn:ietf:wg:oauth:2.0:oob'],
        'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
        'token_uri': 'https://oauth2.googleapis.com/token'
    }
}, scopes=SCOPE)

# Run flow and get credentials
creds = flow.run_console()
print('Access token:', creds.token)