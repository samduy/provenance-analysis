#!/bin/python

import sys
import json
#import pycurl
import requests
#from StringIO import StringIO

GITHUB_URL = 'https://api.github.com'
SEARCH_URL = GITHUB_URL+'/search'
TOKEN = 'token'
TOKEN_FILE = "./token"

#TODO: Consider using PyGithub if neccesary.

# Check arguments
if len(sys.argv) < 2:
  print "Usage: %s <category:repositories|users|commits|code|issues> <keyword>" %sys.argv[0]
  sys.exit()
else: 
  category = str(sys.argv[1])
  keyword = str(sys.argv[2])
  query = category + "?q=" + keyword

url = SEARCH_URL+"/"+query

# Check token
try:
  f = open(TOKEN_FILE, "r")
except:
  print "Unable to get token key. Please get the Github API token key for your account and save it in: " + TOKEN_FILE
  print '$ curl -i -u <YourUserName> -d \'{"scopes": ["repo", "user"], "note": "Getting-started"}\' https://api.github.com/authorizations'
  sys.exit()
token_key = f.read().strip()
TOKEN = TOKEN + " " + token_key

# Request

# (CURL way)
# buffer = StringIO()
# c = pycurl.Curl()
# c.setopt(c.URL, url)
# c.setopt(c.WRITEDATA, buffer)
# c.perform()
# c.close()
# 
# body = buffer.getvalue()

# (Classic way)
r = requests.get(url, headers={'Authorization':TOKEN})
if (r.ok): body = r.text

#print body

# Extract JSON data
data = json.loads(body)
if (category != "code"):
  print data
else:
  for i in data["items"]:
    repo = i["repository"]
    repo_name = repo["name"]
    repo_full_name = repo["full_name"]
    owner_name = repo["owner"]["login"]
    html_url = repo["html_url"]
    print  html_url 

