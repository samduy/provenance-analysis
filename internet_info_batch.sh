#!/bin/bash

# Check argument
if [ $# -lt 3 ]; then
        echo "Usage $0 <interesting_dir_list> <interesting_files_list> <output_file>"
        exit 1
fi

# Check file
if [ ! -f $1 ]; then
        echo "Invalid file: $1"
        exit 1
fi

# Check file
if [ ! -f $2 ]; then
        echo "Invalid file: $2"
        exit 1
fi

# Check file
if [ ! -f $3 ]; then
        echo "Invalid file: $3"
        exit 1
fi

dirs_file=$1
files_file=$2
output=$3
touch ${output}
count=0

# current module name
MODULE="internet_info"

# cache file to store current progress
CACHE_CNT=.${MODULE}_cnt.cache
# cache file to store current processed data
CACHE_DAT=.${MODULE}_dat.cache

# if the cache data is not existed
if [ ! -f ${CACHE_DAT} ]; then
    touch ${CACHE_DAT}
fi

if [ -f ${CACHE_CNT} ]; then
    last_cnt=$(head -1 ${CACHE_CNT})
    if [ ${last_cnt} -gt 0 ]; then
	#count=${last_cnt}
	>&3 echo "[${MODULE}] Resuming from ${last_cnt}."
    else
	last_cnt=0
    fi
fi

# Process
dirslist=$(cat ${dirs_file})
n=$(echo ${dirslist} | wc -w) 
for line in ${dirslist}
do
  count=$((${count}+1))
  if [ ${count} -lt ${last_cnt} ]; then
    continue # skip already done parts
  fi
  echo ${count} > ${CACHE_CNT} # save current progress
  progress=$((100*${count}/n))
  echo -ne ' Running...('${progress}'%)\r'
  ./internet_info.sh ${line} ${files_file} >> ${CACHE_DAT}
done

# output final result
cat ${CACHE_DAT} >> ${output} &&
#remove cache files
rm ${CACHE_CNT} ${CACHE_DAT}
