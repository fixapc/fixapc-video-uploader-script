import os
import subprocess
from googleapiclient.discovery import build

# Set up the Google Custom Search API client
API_KEY = 'YOUR_API_KEY_HERE'
CSE_ID = 'YOUR_CSE_ID_HERE'
service = build('customsearch', 'v1', developerKey=API_KEY)

# Define the fzf command and preview script
FZF_CMD = 'fzf --preview="curl -s {} | feh -"' # You can modify this to use your preferred image viewer
PREVIEW_SCRIPT = 'items[{}].link'

# Search for images using the Google Custom Search API
def search_images(query):
    results = service.cse().list(q=query, cx=CSE_ID, searchType='image').execute()
    items = results['items']
    return items

# Generate the fzf image search utility with preview
def fzf_image_search(query):
    items = search_images(query)
    links = [item['link'] for item in items]
    fzf_input = '\n'.join(links)
    preview_cmds = [PREVIEW_SCRIPT.format(i) for i in range(len(items))]
    preview_script = '\n'.join(preview_cmds)
    fzf_cmd = FZF_CMD.format(preview_script)
    subprocess.run(fzf_cmd, input=fzf_input.encode(), text=True)

# Run the fzf image search utility
if __name__ == '__main__':
    query = input('Search images: ')
    fzf_image_search(query)
