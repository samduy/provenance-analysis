#!/bin/bash

# List all libraries exist in usr/lib directory

# Check argument
if [ $# -eq 0 ]; then
        echo "Usage $0 \"<dir1> <dir2> ...\""
        exit 1
fi

scan_dir=$1
file_types=$2

# Create array of file extensions
IFS='|' read -r -a array <<< "$file_types"


# Formulate the search command
cmd="find $scan_dir -type f -name \"*.dUmmy\""
for element in "${array[@]}"
do cmd="$cmd -o -name \"*.$element\""
done

# Execute the final search command
eval $cmd
