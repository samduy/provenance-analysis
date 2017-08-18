#!/bin/bash

# List up all files that are installed and managed by PIP

# Check argument
if [ $# -lt 2 ]; then
        >&2 echo "Usage $0 <pip_pkgnames_file> <output_file>"
        exit 1
fi

# Check file
if [ ! -f $1 ]; then
        >&2 echo "Invalid file."
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
for pkgname in ${pkgnames}
do
  count=$((${count}+1))
  progress=$((100*${count}/n))
  echo -ne ' Running...('${progress}'%)\r'
  pipshow=$(pip show -f ${pkgname} 2> /dev/null | tail -n +8)
  #filepaths=$(echo "${pipshow}" | tail -n +4 | grep -v "Cannot" |sed -r 's/ //g')
  filepaths=$(echo "${pipshow}" | tail -n +4 |sed -r 's/ //g')
  location=$(echo "${pipshow}" | head -1 | awk '{print $2}')
  #echo "$pipshow"
  #echo "$location"
  #echo "$filepaths"
  #echo "${filepaths}" | while read path
  for path in ${filepaths}
    do
      if [[ ${path} == *"Cannotlocate"* ]]; then
	find ${location}/${pkgname}* >> ${output}
      else
	echo ${location}/${path} >> ${output}
      fi
    done
done
