#!/bin/python

import sys
import json
import requests

GITHUB_URL = 'https://api.github.com'
SEARCH_URL = GITHUB_URL+'/repos'

#TODO: Consider using PyGithub if neccesary.

# Check arguments
if len(sys.argv) < 2:
  print "Usage: %s <user> <repo>" %sys.argv[0]
  sys.exit()
else: 
  user = str(sys.argv[1])
  repo = str(sys.argv[2])

url = SEARCH_URL+"/"+user+"/"+repo
urltag = url + "/tags"
urlrel = url + "/releases"

# Request
r = requests.get(urlrel)
if ((r.ok) and (len(r.text) > 2)): #work-around
  body = r.text
  print body
else: 
  r = requests.get(urltag)
  if (r.ok): body = r.text
  else: body = None

#print body

if (body):
  # Extract JSON data
  data = json.loads(body)
  print data
else: 
  print "No data."
