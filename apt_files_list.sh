#!/bin/bash

# List up all files that are installed by all packages that managed by APT

# Check argument
if [ $# -lt 2 ]; then
        echo "Usage $0 <apt_pkgnames_file> <output_file>"
        exit 1
fi

# Check file
if [ ! -f $1 ]; then
        echo "Invalid file."
        exit 1
fi

# Remove old file
if [ -f $2 ]; then
        rm $2
fi

input=$1
output=$2
touch ${output}
count=0

# Process
pkgnames=$(cat ${input} | sort | uniq)
n=$(echo ${pkgnames} | wc -w | awk '{print $1}')
for pkg in ${pkgnames}
do
  count=$((${count}+1))
  progress=$((100*${count}/n))
  echo -ne ' Running...('${progress}'%)\r'
  dpkg-query -L $pkg >> ${output}
done
