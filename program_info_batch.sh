#!/bin/bash

# Check argument
if [ $# -lt 2 ]; then
        echo "Usage $0 <interesting_dir_list> <output_file>"
        exit 1
fi

# Check file
if [ ! -f $1 ]; then
        echo "Invalid file: $1"
        exit 1
fi

dirs_file=$1
output=$2
touch ${output}
count=0

# Process
dirslist=$(cat ${dirs_file})
n=$(echo ${dirslist} | wc -w) 
for line in ${dirslist}
do
  count=$((${count}+1))
  progress=$((100*${count}/n))
  echo -ne ' Running...('${progress}'%)\r'
  ./program_info.sh ${line} >> ${output}
done
