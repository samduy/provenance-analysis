#!/bin/bash

# Check argument
if [ $# -lt 2 ]; then
	echo "Usage $0 <files.list> <output>"
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

CHECKLIST=(README VERSION CHANGELOG LICENSE)

# Test function: a new Algorithm-D
# Check the existence of any of the files in the list: CHECKLIST
function test {
  for f in ${CHECKLIST[@]}
  do
    #echo $f
    cnt=$(find $1 -maxdepth 1 -name ${f}* | wc -l)
    #echo $cnt
    if [ $cnt -gt 0 ]
    then
      echo "y"
      return 1
    fi
  done
  
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
      echo $path >> ${output}
    fi
    #echo ${verified_paths[${#verified_paths[@]}-2]}
  fi
done
