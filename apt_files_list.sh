#!/bin/bash

# List up all files that are installed by all packages that managed by APT

# Check argument
if [ $# -eq 0 ]; then
        echo "Usage $0 <apt_pkgnames_file>"
        exit 1
fi

# Check file
if [ ! -f $1 ]; then
        echo "Invalid file."
        exit 1
fi

# Process
#cat $1 | while read line; do dpkg-query -L $line; done | grep "usr/lib/*."
cat $1 | while read line; do dpkg-query -L $line; done