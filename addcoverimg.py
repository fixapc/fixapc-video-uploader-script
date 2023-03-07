#!/root/anacoda3/bin/python
import os
import requests
import shutil
from bs4 import BeautifulSoup
from urllib.parse import urlparse
import subprocess

# set the search keywords
search_query = "gentoo logo"
file_type = "png"

# get the first word in the search query
query_words = search_query.split()
if len(query_words) > 0:
    first_word = query_words[0]
else:
    first_word = "image"

# set the number of images to download
num_images = 20

# set the directory to save the images
save_dir = "images"

# create the save directory if it doesn't exist
if not os.path.exists(save_dir):
    os.makedirs(save_dir)

# perform the Google search and download the images
url = f"https://www.google.com/search?q={search_query}&source=lnms&tbm=isch&tbs=imgo:1"
response = requests.get(url)

soup = BeautifulSoup(response.text, "html.parser")
image_links = soup.select("div.rg_i")

for i, img in enumerate(image_links[:num_images]):
    img_url = img.select_one("img.rg_i")["data-src"]
    parsed_url = urlparse(img_url)
    if not parsed_url.scheme:
        img_url = f"http:{img_url}"
    if not parsed_url.netloc:
        img_url = f"http://www.google.com{img_url}"
    filename = f"{first_word}_{i+1}.{file_type}"
    filepath = os.path.join(filename)

    try:
        response = requests.get(img_url, stream=True)
        with open(filepath, "wb") as out_file:
            shutil.copyfileobj(response.raw, out_file)
    except Exception as e:
        print(f"Failed to download {filename}: {e}")

# show a preview of the images using fzf
image_files = [f for f in os.listdir(
    save_dir) if os.path.isfile(os.path.join(f))]
image_files.sort()
fzf_command = f"fzf --preview 'feh {os.path.join('{}')}' --prompt='Select image: ' --ansi"
selected_file = subprocess.check_output(
    fzf_command, shell=True, text=True).strip()
if selected_file:
    # rename the selected file to "image.png"
    new_filepath = os.path.join("image.png")
    os.rename(os.path.join(selected_file), new_filepath)
    print(f"Renamed {selected_file} to image.png")
else:
    print("No image selected.")
