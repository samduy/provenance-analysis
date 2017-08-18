#!/bin/bash

# Check argument
if [ $# -eq 0 ]; then
	>&2 echo "Usage: $0 <binary_file>"
	exit 1
fi

# Process
md5sum $1 | awk '{print $1}'
