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

# MAGIC NUMBER! :)
THRESHOLD=7

# Test function: is (all files and sub-dirs inside) the directory the same packages:
function test {
  cd $1
  mtime_count=$(stat -c '%y' ./* | awk '{print $1}' | sort | uniq -c | sort -nr | wc -l)
  if [ $mtime_count -lt $THRESHOLD ]
  then
    echo "y"
  else
    echo "n"
  fi
}

# The directory-under-test (DUT) IS a package directory if and only if:
#   1. It PASSES the test itself (all of its files and sub-dirs are from the same package)
# AND:
#   2. Its direct parent FAILS the test (the parent's files and sub-dirs are from more than one package)

# Process
full_dirs=$(cat ${input} | xargs dirname | sort | uniq)

verified_paths=()
checked_paths=()

count=0
n=$(echo ${full_dirs} | wc -w)
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
