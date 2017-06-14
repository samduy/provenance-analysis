#!/bin/bash

# List up all files that are installed and managed by PIP

# Check argument
if [ $# -eq 0 ]; then
        echo "Usage $0 <pip_pkgnames_file>"
        exit 1
fi

# Check file
if [ ! -f $1 ]; then
        echo "Invalid file."
        exit 1
fi

# Process
cat $1 | while read pkgname
do 
  pipshow=$(pip show -f ${pkgname} | tail -n +8)
  #filepaths=$(echo "${pipshow}" | tail -n +4 | grep -v "Cannot" |sed -r 's/ //g')
  filepaths=$(echo "${pipshow}" | tail -n +4 |sed -r 's/ //g')
  location=$(echo "${pipshow}" | head -1 | awk '{print $2}')
  #echo "$pipshow"
  #echo "$location"
  #echo "$filepaths"
  #echo "${filepaths}" | while read path
  for path in ${filepaths}
    do
      if [[ ${path} == *"Cannotlocate"* ]]; then
	find ${location}/${pkgname}*
      else
	echo ${location}/${path}
      fi
    done
done
