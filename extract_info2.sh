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

# Process
longest_filepath=$(grep $1 $2 | sed -r 's,('$1')/(.*),\2,g' | awk '{print length, $0}' | sort -nr | head -1 | awk '{print $2}')
full_filepath=$1/$longest_filepath
#echo $full_filepath
echo $1:$(stat -c%Y,%y $full_filepath)
