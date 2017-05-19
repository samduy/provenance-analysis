#!/usr/bin/python

import sys
import json
import requests
import os
import time

GITHUB_URL = 'https://api.github.com'
SEARCH_URL = GITHUB_URL+'/search'
TOKEN = 'token'
TOKEN_FILE = "./token"

#TODO: Consider using PyGithub if neccesary.

# Request to GitHub
def github_request(url):
  data = None
  error = None
  hdr={'Authorization':TOKEN}
  #print hdr
  r = ''
  while (r == ''):
    try:
      r = requests.get(url, headers={'Authorization':TOKEN})
    except requests.exceptions.ConnectionError:
      print >> sys.stderr, 'Connection refused. Retry in 5 seconds.'
      time.sleep(5)
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
    print >> sys.stderr, "Unable to get token key. Please get the Github API token key for your account and save it in: %s" %filename
    print >> sys.stderr, 'Reference: https://api.github.com/authorizations'
    sys.exit()
  return 'token '+f.read().strip()

## MAIN
# Check arguments
if len(sys.argv) < 2:
  print >> sys.stderr, "Usage: %s <file_path>" %sys.argv[0]
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
while (1):
  data, error = github_request(url)
  if ( error ):
    msg = str(error["message"])
    if (msg.find("limit exceeded") > 0):
      print >> sys.stderr, "Error: %s Sleep 5 seconds." % msg
      time.sleep(5)
    elif (msg.find("abuse detection") > 0):
      print >> sys.stderr, "Error: %s Sleep 60 seconds." % msg
      time.sleep(60)
    else:
      break
  else:
    break
  
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
  print >> sys.stderr, "Error: " + error["message"]
