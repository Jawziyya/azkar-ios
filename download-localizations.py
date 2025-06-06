#!/opt/homebrew/bin/python3

import requests
import zipfile
from io import BytesIO
from os import system, path
from shutil import move, rmtree
import sys

# Constants
API_KEY = 'uNCK7IUKsZ6VCwl3dMYMUYFiLaPndPla'
RESOURCES_DIR = 'Azkar/Resources/'
LOCALIZATION_KEYS = ['strings']

def get_url(key):
    """Generate the URL for the localization API."""
    return f'http://localise.biz/api/export/archive/{key}/ru/en/tr.zip'

def get_container_folder_path(key):
    """Generate the container folder path for the given key."""
    return f'azkar-{key}-archive'

def download_and_extract_localizations():
    """Download and extract localization files."""
    urls = [get_url(key) for key in LOCALIZATION_KEYS]
    
    for i, (key, url) in enumerate(zip(LOCALIZATION_KEYS, urls)):
        try:
            print(f'Requesting localizations for {url}')
            request_url = f'{url}/?key={API_KEY}'
            response = requests.get(request_url, stream=True)
            response.raise_for_status()  # Raise an exception for HTTP errors
            
            with zipfile.ZipFile(BytesIO(response.content)) as zip_file:
                for file in zip_file.filelist:
                    if 'lproj' in file.filename:  # Fixed the condition
                        extracted_file = zip_file.extract(file.filename, RESOURCES_DIR)
                        file_path = extracted_file.replace(f"{get_container_folder_path(key)}/", '')
                        move(extracted_file, file_path)
                        
        except requests.exceptions.RequestException as e:
            print(f"Error downloading {key} localizations: {e}")
            sys.exit(1)
        except zipfile.BadZipFile:
            print(f"Error extracting zip file for {key}")
            sys.exit(1)
        except Exception as e:
            print(f"Unexpected error: {e}")
            sys.exit(1)
    
    print('Exported all localizations 📦')

def cleanup_temp_files():
    """Remove temporary directories created during extraction."""
    try:
        for key in LOCALIZATION_KEYS:
            folder_path = path.join(RESOURCES_DIR, get_container_folder_path(key))
            if path.exists(folder_path):
                rmtree(folder_path)
        print('Removed temp files 🗑')
    except Exception as e:
        print(f"Error cleaning up temporary files: {e}")

def generate_swift_files():
    """Generate Swift localization files using SwiftGen."""
    try:
        system('swiftgen config run')
        print('Generated Localizations.swift file 🚀')
    except Exception as e:
        print(f"Error generating Swift files: {e}")
        return False
    return True

def main():
    """Main function to orchestrate the localization download process."""
    download_and_extract_localizations()
    cleanup_temp_files()
    if generate_swift_files():
        print("All tasks completed successfully! ✅")
    else:
        print("Some tasks failed. Check the logs for details.")
        sys.exit(1)

if __name__ == "__main__":
    main()
