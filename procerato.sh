#!/bin/bash

# Program: PROCERATO - Program Provenance Analysis
# Author: Duy KHUONG <khuong@eurecom.fr>

echo "List up all packages are currently installed and managed by APT"
./apt_list.sh > apt.list

echo "List up all files that are installed by packages managed by APT"
./files_list.sh > apt_files.list

echo "List up all libraries (binaries) inside /usr/lib directory"
./usr_lib_list.sh > usr_lib.list

echo "List up all libraries exist but are not being managed by APT"
./check.sh apt_files.list usr_lib.list > external.list

echo "Filter only files .so in usr/lib directory"
cat files.list | grep "\.so" > files_so.list

echo "List up only files that not installed by APT"
sort usr_lib.list files_so.list files_so.list | uniq -u
