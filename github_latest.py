#!/bin/python

import sys
import json
import requests

GITHUB_URL = 'https://api.github.com'
SEARCH_URL = GITHUB_URL+'/repos'
TOKEN = ''
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

# Get the created date of specific commit
def getCommitDate(commit_sha):
  global urlci, TOKEN
  body = None
  r = requests.get(urlci+"/"+commit_sha, headers={'Authorization':TOKEN})
  if (r.ok):
    body = r.text
  if (body):
    data = json.loads(body)
    return data['committer']['date']
  return "N/A"

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
if len(sys.argv) < 3:
  print "Usage: %s <user> <repo>" %sys.argv[0]
  sys.exit()
else: 
  user = str(sys.argv[1])
  repo = str(sys.argv[2])

# Formulate the request url
url = SEARCH_URL+"/"+user+"/"+repo
#urltag = url + "/tags?page=1&per_page=1"
urltag = url + "/tags"
urlrel = url + "/releases/latest"
urlci = url + "/commits"

# Token key
TOKEN = load_token_key(TOKEN_FILE)

# Request for PUBLISHED RELEASES
data, error = github_request(urlrel)

# Request for COMMITS
data_ci, error_ci = github_request(urlci)

# Print results
if (data):
  print "[LATEST_RELEASE]"+ data[u'name'] + ",tag:" + data[u'tag_name'] + ",created_at:" + data[u'created_at'] + ",published_at:" + data[u'published_at']
else:
  print "[LATEST_RELEASE]None."
  #print "No published releases."
  #print "Error: " + error["message"]

if (data_ci):
  #print data_ci
  #for ci in data_ci:
    ci = data_ci[0]
    sha = ci["sha"]
    commit = ci["commit"]
    date = commit["committer"]["date"]
    print "[LATEST_COMMIT]"+sha +",created_at:"+ date
else:
  print "Error: " + error_ci["message"]
