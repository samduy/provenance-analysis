#!/bin/bash

# Check argument
if [ $# -eq 0 ]; then
	>&2 echo "Usage $0 <binary_file>"
	exit 1
fi

# Check file
if [ ! -f $1 ]; then
	>&2 echo "Invalid file."
	exit 1
fi

# Process
echo $1","`./get_md5sum.sh $1`","`./get_buildid.sh $1`","`./get_stat.sh $1`
