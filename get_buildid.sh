#!/bin/bash

# Check argument
if [ $# -eq 0 ]; then
	echo "Usage: $0 <binary_file>"
	exit 1
fi

# Process
file $1 | awk -F'=' '{print $2}'| awk -F',' '{print $1}'
