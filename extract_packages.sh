#!/bin/bash

# Check argument
if [ $# -lt 2 ]; then
	>&2 echo "Usage $0 <files.list> <output>"
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

# current module name
MODULE="extract_packages"

# cache file to store current progress
CACHE_CNT=.${MODULE}_cnt.cache
# cache file to store current processed data
CACHE_DAT=.${MODULE}_dat.cache

# if the cache data is not existed
if [ ! -f ${CACHE_DAT} ]; then
    touch ${CACHE_DAT}
fi

last_cnt=0
if [ -f ${CACHE_CNT} ]; then
    last_cnt=$(head -1 ${CACHE_CNT})
    if [ ${last_cnt} -gt 0 ]; then
        #count=${last_cnt}
        >&3 echo "[${MODULE}] Resuming from ${last_cnt}."
    else
        last_cnt=0
    fi
fi

CHECKLIST=(HISTORY VERSION CHANGELOG LICENSE)

# Test function: a new Algorithm-D
# Check the existence of any of the files in the list: CHECKLIST
function test {
  c=$(find $1 -maxdepth 1 -name "*README*" | wc -l)
  if [ $c -gt 0 ]
  then
    find_cmd="find $1 -maxdepth 1 -name _dUmmY_"
    for f in ${CHECKLIST[@]}
    do
      #echo $f
      find_cmd+=" -o -name \"*${f}*\""
    done
    cnt=$(eval $find_cmd | wc -l)
    #echo $cnt
    if [ $cnt -gt 0 ]
    then
      echo "y"
      return 1
    fi
  fi
  
  #else
  echo "n"
  return 0
}

# The directory-under-test (DUT) IS a package directory if and only if:
#   1. It PASSES the test itself (all of its files and sub-dirs are from the same package)
# AND:
#   2. Its direct parent FAILS the test (the its files and sub-dirs are from more than one package)

# Process
full_dirs=$(cat ${input} | xargs dirname | sort | uniq)

verified_paths=()
checked_paths=()

count=0
n=$(echo ${full_dirs} | wc -w)
#echo $n
for path in $full_dirs; do
  count=$((${count}+1))
  if [ ${count} -lt ${last_cnt} ]; then
    continue # skip already done parts
  fi
  echo ${count} > ${CACHE_CNT} # save current progress
  progress=$((100*${count}/n))
  echo -ne ' Running...('${progress}'%)\r'
  parent_path=$(dirname $path)
  parent_test=$(test $parent_path)
  self_test=$(test $path)
  while [ $self_test == "y" -a $parent_test == "y" ] 
  do 
    if [[ ! "${checked_paths[@]}" =~ "${path}" ]]; then
      checked_paths+=("${path}")
      path=${parent_path}
      #echo path:$path
      parent_path=$(dirname $path)
      parent_test=$(test $parent_path)
      self_test=$(test $path)
    else
      break
    fi
  done
  #echo $self_test:$parent_test
  if [ $self_test == "y" -a $parent_test == "n" ]; then
    if [[ ! "${verified_paths[@]}" =~ "${path}" ]]; then
      verified_paths+=("$path")
      echo $path >> ${CACHE_DAT}
    fi
    #echo ${verified_paths[${#verified_paths[@]}-2]}
  fi
done

# output final result
cat ${CACHE_DAT} >> ${output} &&
#remove cache files
rm .*.cache
