#!/usr/bin/python

import sys
import csv
import json
import os
from datetime import datetime

manualTabulate = 0
try:
  from tabulate import tabulate
except:
  manualTabulate = 1

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
  #else: #dont care
  #  result[key2] = row2

# Determine result
for k in result:
  item = result[k]
  try:
	latest_datetime = datetime.strptime(item['committed_date'], DATETIME_FORMAT_IN)
  except:
	latest_datetime = '-'
  try:
	local_datetime = datetime.fromtimestamp(int(item['modified_datetime']))
  except:
	local_datetime = '-'

  # Package name
  item.update({'Package': os.path.basename(k)})
 
  # Source
  item.update({'Source': 'GitHub'})

  # Latest updated or not
  try:
    if latest_datetime > local_datetime:
      item.update({'Updated':'N'})
    else:
      item.update({'Updated':'Y'})
  except:
      item.update({'Updated':'-'})


  # Active development or not
  try:
    if int(latest_datetime.strftime('%s')) < (int(now.strftime('%s')) - int(active_threshold)):
      item.update({'Active':'N'})
    else:  
      item.update({'Active':'Y'})
  except:
      item.update({'Active':'-'})

  # Version / Date information
  try:
    item.update({'Local': local_datetime.strftime(DATETIME_FORMAT_OUT)})
  except:
    item.update({'Local': '     -    '})
  try:
	item.update({'Latest': latest_datetime.strftime(DATETIME_FORMAT_OUT)})
  except:
	item.update({'Latest': '     -    '})

# PRINT RESULT
if (manualTabulate):
  padding = "                              " # 30 chars
  header =  "|   Path  " + padding[:20]
  header += "|   Name   " + padding[:10]
  header += "|   Source   "
  header += "|   Updated  "
  header += "|   Active   "
  header += "|   Local    "
  header += "|   Latest   "
  header += "|"
  print header
  for k in result:
    item = result[k]
    path = k
    if len(path) >= 27:
      path = path[:25]+'.'
    row =  "|  " + path + padding[:27-len(path)]
    pkgname = item['Package']
    if len(pkgname) >= 17:
      pkgname = pkgname[:15]+'.'
    row += "|   " + pkgname + padding[:17-len(pkgname)]
    row += "|   " + item['Source']  + padding[:9-len(item['Source'])]
    row += "|   " + item['Updated'] + padding[:9-len(item['Updated'])]
    row += "|   " + item['Active']  + padding[:9-len(item['Active'])]
    row += "| " + item['Local']
    row += " | " + item['Latest']
    row += " |"
    print row
else: # Use Tabulate to generate nicer table
  table = []
  for k in result:
    item = result[k]
    table.append([k,item['Package'], item['Source'], item['Updated'], item['Active'], item['Local'], item['Latest']])
  print tabulate(table, headers=['Path', 'Name', 'Source', 'Updated', 'Active', 'Local', 'Latest'])
