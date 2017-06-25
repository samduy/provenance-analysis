#!/bin/bash

# Check argument
if [ $# -lt 1 ]; then
        echo "Usage $0 <output_file>"
        exit 1
fi

# Remove old file
if [ -f $1 ]; then
	rm $1
fi

output=$1
touch ${output}
count=0

# Print all packages that are installed and managed by APT
namelist=$(apt list --installed | sed -nr 's/\// /p'  | awk '{print $1}')
n=$(echo ${namelist} | wc -w | awk '{print $1}') 
for line in ${namelist}
do
  count=$((${count}+1))
  progress=$((100*${count}/n))
  echo -ne ' Running...('${progress}'%)\r'
  dpkg-query -l ${line}'*' | grep '^ii' | awk '{print $2}' >> ${output}
done
