#!/usr/bin/python

import sys
import csv
import json
import os
from datetime import datetime
from tabulate import tabulate

# Some settings
DATETIME_FORMAT_IN = '%Y-%m-%dT%H:%M:%SZ'
DATETIME_FORMAT_OUT = '%Y-%m-%d'
active_threshold = 365*24*60*60	  # 365 days (1 year)
now = datetime.now()
today = now.day

# Variables
INTERNET_RAW_FILE = ''
LOCAL_RAW_FILE = ''

## MAIN
# Check arguments
if len(sys.argv) < 3:
  print >> sys.stderr, "Usage: %s <internet_info.dat> <local_info.dat>" %sys.argv[0]
  sys.exit()
else:
  INTERNET_RAW_FILE = str(sys.argv[1])
  LOCAL_RAW_FILE = str(sys.argv[2])

# Load raw data
try:
  internet_info_rdr = csv.DictReader(open(INTERNET_RAW_FILE))
  local_info_rdr = csv.DictReader(open(LOCAL_RAW_FILE))
except:
  print >> sys.stderr, "Error: Invalid raw data files."
  sys.exit()

# Process data
result = {}

for row in internet_info_rdr:
  key = row.pop('path')
  if key in result:
    # duplicate row handling
    pass
  result[key] = row

for row2 in local_info_rdr:
  key2 = row2.pop('path')
  if key2 in result:
    # duplicate row handling
    result[key2].update(row2)
  else:
    result[key2] = row2

# Determine result
for k in result:
  item = result[k]
  latest_datetime = datetime.strptime(item['committed_date'], DATETIME_FORMAT_IN)
  local_datetime = datetime.fromtimestamp(int(item['modified_datetime']))

  # Package name
  item.update({'Package': os.path.basename(k)})
 
  # Source
  item.update({'Source': 'GitHub'})

  # Latest updated or not
  if  latest_datetime > local_datetime:
    item.update({'Updated':'N'})
  else:
    item.update({'Updated':'Y'})

  # Active development or not
  if int(latest_datetime.strftime('%s')) < (int(now.strftime('%s')) - int(active_threshold)):
    item.update({'Active':'N'})
  else:  
    item.update({'Active':'Y'})

  # Version / Date information
  item.update({'Local': local_datetime.strftime(DATETIME_FORMAT_OUT)})
  item.update({'Latest': latest_datetime.strftime(DATETIME_FORMAT_OUT)})

# PRINT RESULT
table = []
for k in result:
  item = result[k]
  table.append([k,item['Package'], item['Source'], item['Updated'], item['Active'], item['Local'], item['Latest']])

print tabulate(table, headers=['Path', 'Name', 'Source', 'Updated', 'Active', 'Local', 'Latest'])
