#!/opt/homebrew/bin/python3

import requests
import zipfile
from io import BytesIO
from os import system, path
from shutil import move, rmtree

def url(key):
    return 'http://localise.biz/api/export/archive/' + key + '/ru/en/tr/ar.zip'

strings_url = url('strings')
plural_string_url = url('stringsdict')

api_key = 'uNCK7IUKsZ6VCwl3dMYMUYFiLaPndPla'
resources = 'Azkar/Resources/'

keys = ['strings', 'stringsdict']
urls = [strings_url, plural_string_url]

def containerFolderPath(key):
    return 'azkar-'+key+'-archive'

for i in range(0, len(keys)):
    key = keys[i]
    url = urls[i]
    print('Requsting localizations for' + url)
    requestUrl = url + '/?key=' + api_key
    request = requests.get(requestUrl, stream=True)
    zip = zipfile.ZipFile(BytesIO(request.content))
    for file in zip.filelist:
        if file.filename.find('lproj'):
            file = zip.extract(file.filename, resources)
            filePath = file.replace(containerFolderPath(key) + '/', '')
            move(file, filePath)

print('Exported all localizations 📦')

for key in keys:
    path = containerFolderPath(key)
    rmtree(resources + path)

print('Removed temp files 🗑')

system('swiftgen config run')

print('Generated Localizations.swift file 🚀')

print ("All tasks completed successfully! ✅")
