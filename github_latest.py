#!/bin/python

import sys
import json
import requests
from pprint import pprint

GITHUB_URL = 'https://api.github.com'
SEARCH_URL = GITHUB_URL+'/repos'

#TODO: Consider using PyGithub if neccesary.

def getCommitDate(commit_sha):
  global url
  body = None

  r = requests.get(url+"/git/commits/"+commit_sha)
  if (r.ok):
    body = r.text
  if (body):
    data = json.loads(body)
    return data['committer']['date']
  else:
    return "N/A"

# Check arguments
if len(sys.argv) < 2:
  print "Usage: %s <user> <repo>" %sys.argv[0]
  sys.exit()
else: 
  user = str(sys.argv[1])
  repo = str(sys.argv[2])

# Formulate the request url
url = SEARCH_URL+"/"+user+"/"+repo
urltag = url + "/tags"
urlrel = url + "/releases/latest"

body = None
rtype = None  #Type: Published release OR tag

# Request
r = requests.get(urlrel)
if ((r.ok) and (len(r.text) > 2)): #work-around
  rtype = "[RELEASE]"
  body = r.text
  #print body
else: 
  rtype = "[TAG]"
  r = requests.get(urltag)
  if (r.ok): body = r.text
  else: body = None

#print body

if (body):
  # Extract JSON data
  data = json.loads(body)

  if (rtype != "[RELEASE]"):
    len = len(data)
    for i in data:
      commit = i[u'commit'][u'sha']
      print i[u'name'] + ":" + commit + ":" + getCommitDate(commit)
  else:
    print rtype + ",name:"+ data[u'name'] + ",tag:" + data[u'tag_name'] + ",created_at:" + data[u'created_at'] + ",published_at:" + data[u'published_at']
else: 
  print "No data."
