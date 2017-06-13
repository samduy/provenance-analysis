#!/usr/bin/python

import sys
import json
import requests
import os
import time
import urllib

GOOG_URL = 'https://www.googleapis.com'
SEARCH_URL = GOOG_URL+'/customsearch/v1'
SID = '017034373173768416011:ioda6vk7d5m' # Custom Search Engine ID
TOKEN = ''
TOKEN_FILE = "./token_google"
NUM = 1

# Request to Google
def google_request(url):
  data = None
  error = None
  r = ''
  while (r == ''):
    try:
      r = requests.get(url)
    except requests.exceptions.ConnectionError:
      print >> sys.stderr, 'Connection refused. Retry in 5 seconds.'
      time.sleep(5)
  if ((r.ok) and (len(r.text) > 2)): #work-around
    data = json.loads(r.text)
  else:
    error = json.loads(r.text)
  return data, error

# Load the Google token key from file
def load_token_key(filename):
  key = ""
  # Check token
  try:
    f = open(filename, "r")
    key = f.read().strip()
  except:
    print >> sys.stderr, "Unable to get token key. Please get the Google API token key for your account and save it in: %s" %filename
    print >> sys.stderr, 'Reference: https://cse.google.com/cse/setup'
    sys.exit()
  return key

## MAIN
def main():
  global TOKEN, TOKEN_FILE, SEARCH_URL, NUM
  # Check arguments
  if len(sys.argv) < 2:
    print >> sys.stderr, "Usage: %s <search_string> [numer_of_results]" %sys.argv[0]
    sys.exit()
  else: 
    #file_path = str(sys.argv[1])
    #filename = os.path.basename(file_path)
    #path = os.path.dirname(file_path)
    #query = "path:" + path + " filename:" + filename
    query = urllib.quote_plus(str(sys.argv[1])) 
    if (len(sys.argv) >= 3):
    # Number of returning results
      NUM = int(sys.argv[2])
  
  # Token key
  TOKEN = load_token_key(TOKEN_FILE)
  
  # Full URL request
  url = SEARCH_URL+"?cx="+SID+"&key="+TOKEN+"&q="+query+"&num="+str(NUM)
  #print >> sys.stderr, "URL: " + url

  # Request
  while (1):
    data, error = google_request(url)
    if ( error ):
      err = error['error']
      code = str(err['code'])
      msg = str(err['message'])
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
    #print data
    try:
      for i in data["items"]:
        title = i["title"]
        formattedUrl = i["formattedUrl"]
        print  "["+title+"]("+formattedUrl+")"
    except:
	print "No result"
  else:
    print "Error ["+code+"]:"+msg

if __name__ == "__main__":
  main()
