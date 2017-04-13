#!/bin/python

import sys
import json
import pycurl
from StringIO import StringIO

GITHUB_URL = 'https://api.github.com'
SEARCH_URL = GITHUB_URL+'/search'

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

# Request
buffer = StringIO()
c = pycurl.Curl()
c.setopt(c.URL, url)
c.setopt(c.WRITEDATA, buffer)
c.perform()
c.close()

body = buffer.getvalue()
print body

#data = json.loads(body)
#print data
