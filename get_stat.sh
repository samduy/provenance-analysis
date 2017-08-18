#!/bin/bash

# Check argument
if [ $# -eq 0 ]; then
	>&2 echo "Usage: $0 <binary_file>"
	exit 1
fi

# Process
#stat -c%n,%s,%Y,%y $1
stat -c%s,%Y,%y $1
