#!/bin/python

import sys
import json
import requests
import os

GITHUB_URL = 'https://api.github.com'
SEARCH_URL = GITHUB_URL+'/search'
TOKEN = 'token'
TOKEN_FILE = "./token"

#TODO: Consider using PyGithub if neccesary.

# Request to GitHub
def github_request(url):
  data = None
  error = None
  r = requests.get(url, headers={'Authorization':TOKEN})
  if ((r.ok) and (len(r.text) > 2)): #work-around
    data = json.loads(r.text)
  else:
    error = json.loads(r.text)
  return data, error

# Load the GitHub token key from file
def load_token_key(filename):
  # Check token
  try:
    f = open(filename, "r")
  except:
    print "Unable to get token key. Please get the Github API token key for your account and save it in: " + filename
    print 'Reference: https://api.github.com/authorizations'
    sys.exit()
  return 'token '+f.read().strip()

## MAIN
# Check arguments
if len(sys.argv) < 2:
  print "Usage: %s <file_path>" %sys.argv[0]
  sys.exit()
else: 
  file_path = str(sys.argv[1])
  filename = os.path.basename(file_path)
  path = os.path.dirname(file_path)
  query = "code?q=path:" + path + " filename:" + filename
  #print query

url = SEARCH_URL+"/"+query

# Token key
TOKEN = load_token_key(TOKEN_FILE)

# Request
data, error = github_request(url)
if (data):
  for i in data["items"]:
    repo = i["repository"]
    repo_name = repo["name"]
    repo_full_name = repo["full_name"]
    owner_name = repo["owner"]["login"]
    html_url = repo["html_url"]
    #print  "owner:"+owner_name+",repo:"+repo_name
    print  owner_name+":"+repo_name
else:
  print "Error: " + error["message"]
