#!/bin/bash

# Program: PROCERATO - Program Provenance Analysis
# Author: Duy KHUONG <khuong@eurecom.fr>

echo "apt-get update"
apt-get update

echo "List up all packages are currently installed and managed by APT"
./apt_list.sh > apt.list &&

echo "List up all files that are installed by packages managed by APT"
./files_list.sh > apt_files.list &&

echo "List up all libraries (binaries) inside /usr/lib directory"
./usr_lib_list.sh > usr_lib.list &&

echo "Filter only files .so which were installed by APT in usr/lib directory"
cat apt_files.list | grep "\.so" > apt_files_so.list &&

echo "List up only files that were not installed by APT"
sort usr_lib.list apt_files_so.list apt_files_so.list | uniq -u > interesting_files.list

echo "Extract information of each interesting file"
echo "file_path,MD5sum,Build-ID,Size(bytes),ModifiedTime,ModifiedTime(HumanReadable)" > files_info.dat
cat interesting_files.list | while read line; do ./extract_info.sh $line; done >> files_info.dat
