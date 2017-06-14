#!/usr/bin/python

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
    print >> sys.stderr, "Unable to get token key. Please get the Github API token key for your account and save it in: " + filename
    print >> sys.stderr, 'Reference: https://api.github.com/authorizations'
    sys.exit()
  return 'token '+f.read().strip()

## MAIN
# Check arguments
if len(sys.argv) < 2:
  print >> sys.stderr, "Usage: %s <user>:<repo>" %sys.argv[0]
  sys.exit()
else: 
  user_repo = str(sys.argv[1])
  if (user_repo.find(":") >= 0):
    user = user_repo.split(":")[0]
    repo = user_repo.split(":")[1]
  else:
    print >> sys.stderr, "%s should be in the right format <user>:<repo>" %user_repo
    sys.exit()

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
result = "user:"+user+",repo:" + repo

if (data):
  latest_release = data[u'name']
  rel_tag_name = data[u'tag_name']
  rel_created_date = data[u'created_at']
  rel_published_date = data[u'published_at']
  result += ",latest_release:"+str(latest_release)+",released_date:"+str(rel_published_date)
else:
  result += ",latest_release:n/a"
  #print "Error: " + error["message"]

if (data_ci):
  #print data_ci
  #for ci in data_ci:
    ci = data_ci[0]
    sha = ci["sha"]
    commit = ci["commit"]
    ci_date = commit["committer"]["date"]
    result += ",latest_commit:"+sha+",committed_date:"+ci_date
else:
  result += ",latest_commit:n/a"
  #print "Error: " + error_ci["message"]

print result
