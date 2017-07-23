#!/bin/bash

# Check argument
if [ $# -lt 1 ]; then
	echo "Usage $0 <dir>"
	exit 1
fi

# Check folder
if [ ! -d $1 ]; then
	echo "Invalid folder: $1"
	exit 1
fi

# Process
echo $1,$(stat -c%y $1/* | awk '{print $1}' | uniq | sort -rn | head -1)
