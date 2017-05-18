#!/bin/bash

# Check argument
if [ ! $# -eq 2 ]; then
	echo "Usage $0 <dir> <files_list>"
	exit 1
fi

# Check file
if [ ! -f $2 ]; then
	echo "Invalid file: $2"
	exit 1
fi

dir=$1
file_list=$2

# Process
NUMBER_OF_FILES=3 # Change this for better determination.

#Get a number of files that have longest file paths inside the program dir
longest_filepaths=$(grep $dir $file_list | sed -r -n 's,('$dir')/(.*),\2,p' | awk '{print length, $0}' | sort -nr | head -$NUMBER_OF_FILES | awk '{print $2}')
#echo $longest_filepaths

#Use GitHub API to search for those filepaths to find their public repo on internet
userrepos=""

for filepath in $longest_filepaths; do \
  #sleep 5 # avoid connection refused from Github server
  internet_repos=$(python ./github_filesearch.py $filepath | sort | uniq -u);
  userrepos=$(echo $userrepos $internet_repos);
done

# Filter the result: get only the repo that appear in all returned results
# (Since each search with individual file path returns more than one possible repo. 
# The one we are looking for is the one that exist in all the returned results.)
for ur in $userrepos; do echo $ur; done | sort | uniq -c | gawk '$1=='$NUMBER_OF_FILES'{print $2}'

#for userrepo in $userrepos; do \
#  echo $dir,$(./github_latest.py $userrepo); 
#done
