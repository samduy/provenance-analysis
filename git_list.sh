#!/bin/bash

# Check argument
if [ $# -eq 0 ]; then
  >&2 echo "Usage: $0 <directory to scan>"
  exit 1
fi

# Process:
# Print all the directory that has `.git` in it
for i in `find $1 -name ".git"`; do \
  PATH=`echo $i | /bin/sed 's,/.git$,,g'`;

  # update git local database
  pushd $PATH > /dev/null 2>&1 && 
  /usr/bin/git fetch -tq > /dev/null 2>&1 && 
  popd > /dev/null 2>&1

  URL=`/bin/grep "url" $i/config | /usr/bin/awk '{print $3}'`; 
  HEADS=$(for j in `/bin/ls $i/refs/heads/`; \
    do echo $j:$(/bin/cat $i/refs/heads/$j); \
    done)
  LATEST_TAGS=$(for j in `/bin/ls $i/refs/tags/ | /usr/bin/sort -r | /usr/bin/head -1`; \
    do echo $j:$(/bin/cat $i/refs/tags/$j); \
    done)

  # Get the date of latest commit in local
  pushd $PATH > /dev/null 2>&1 && 
  LOCAL_DATE=$(/usr/bin/git log -1 --date=short --pretty=format:%ad) &&
  LATEST_DATE=$(/usr/bin/git log -1 origin/master --date=short --pretty=format:%ad) &&
  popd > /dev/null 2>&1

  #echo $PATH,$URL,$HEADS,$LATEST_TAGS;
  echo $PATH,$URL,$LOCAL_DATE,$LATEST_DATE;
  done
