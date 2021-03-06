#!/bin/bash

# List all libraries exist in usr/lib directory

# Check argument
if [ $# -lt 2 ]; then
        >&2 echo "Usage $0 \"<dir1> <dir2> ...\" \"<type1|type2|...>\""
        exit 1
fi

scan_dir=$1
file_types=$2

# Create array of file extensions
IFS='|' read -r -a array <<< "$file_types"

# Formulate the search command
cmd="find $scan_dir -type f"
cmd+=" -name \"README*\" -o -name \"VERSION*\" -o -name \"HISTORY*\" -o -name \"LICENSE*\""
for element in "${array[@]}"
do cmd+=" -o -name \"*.$element\""
done

# Execute the final search command
eval $cmd 2>/dev/null || true
