#!/bin/bash

# Check argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 <directory to scan>"
  exit 1
fi

# Process:
# Print all the directory that has autotools in it (configure.ac, Makefile.am,...)
echo "Print all directory that has autotools in it."
for filename in {"configure.ac","Makefile.am"}; do \
  find $1 -name $filename | sed 's,'$filename'$,,g'; \
  done | sort | uniq
