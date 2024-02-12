import requests
from bs4 import BeautifulSoup
import os

# The URL containing the MP3 files
url = "https://play.pokemonshowdown.com/audio/cries/"

# Directory to save the MP3 files
save_dir = "."

def download_mp3_files(url, save_dir):
    try:
        # Send a GET request to the URL
        response = requests.get(url)
        response.raise_for_status()  # Raise an error for bad responses

        # Parse the HTML content
        soup = BeautifulSoup(response.text, 'html.parser')

        # Find all links in the page and filter for MP3 files
        for link in soup.find_all('a'):
            href = link.get('href')
            if href and href.endswith('.mp3'):
                mp3_url = url + href  # Construct the full URL
                mp3_response = requests.get(mp3_url)
                file_path = os.path.join(save_dir, href)

                # Save the MP3 file
                with open(file_path, 'wb') as file:
                    file.write(mp3_response.content)
                print(f"Downloaded: {href}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Download the MP3 files
download_mp3_files(url, save_dir)
