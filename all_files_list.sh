#!/bin/bash

# List all libraries exist in usr/lib directory

# Check argument
if [ $# -eq 0 ]; then
        echo "Usage $0 \"<dir1> <dir2> ...\""
        exit 1
fi

#find /usr/lib -name "*.so*" -type f
find $1 -name "*.so" -o -name "*.py" -o -name "*.rb" -o -name "*.pyc" -o -name "*.apk" -o -name "*.jar" -o -name "*.sh" -type f
