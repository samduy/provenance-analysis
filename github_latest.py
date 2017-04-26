#!/bin/python

import sys
import json
import requests
from pprint import pprint

GITHUB_URL = 'https://api.github.com'
SEARCH_URL = GITHUB_URL+'/repos'
TOKEN = 'token ed0af45a6427021b17c3a25abfd7728f35a00ce2'

#TODO: Consider using PyGithub if neccesary.

def getCommitDate(commit_sha):
  global url, TOKEN
  body = None

  r = requests.get(url+"/git/commits/"+commit_sha, headers={'Authorization':TOKEN})
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
#urltag = url + "/tags?page=1&per_page=1"
urltag = url + "/tags"
urlrel = url + "/releases/latest"

body = None
rtype = None  #Type: Published release OR tag

# Request
r = requests.get(urlrel, headers={'Authorization':TOKEN})
if ((r.ok) and (len(r.text) > 2)): #work-around
  rtype = "[RELEASE]"
  body = r.text
  #print body
else: 
  rtype = "[TAG]"
  r = requests.get(urltag, headers={'Authorization':TOKEN})
  if (r.ok): body = r.text
  else: body = None

#print body

if (body):
  # Extract JSON data
  data = json.loads(body)

  if (rtype != "[RELEASE]"):
    # Finding the latest tag by comparing its created dates.
    # TODO: this is intensively heavy. Need another solution for better performance.
    for i in data:
      commit = i[u'commit'][u'sha']
      # get the created date of the commit associated with the tag
      date = getCommitDate(commit)
      # add a new field to the item
      i[u'created_at'] = date
      #print i[u'name'] + ":" + commit + ":" + date
    #sort all the tag items by its created date
    sorted_data = sorted(data, key=lambda k:k[u'created_at'], reverse=True)
    #latest tag is the first item of the sorted list
    latest_item = sorted_data[0]
    #print latest_item
    print rtype + ",name:"+ latest_item[u'name'] + ",tag:" + latest_item[u'name'] + ",created_at:" + latest_item[u'created_at']
  else:
    print rtype + ",name:"+ data[u'name'] + ",tag:" + data[u'tag_name'] + ",created_at:" + data[u'created_at'] + ",published_at:" + data[u'published_at']
else: 
  print "No data."
