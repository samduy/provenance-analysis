#!/bin/bash

# Check argument
if [ ! $# -eq 2 ]; then
	echo "Usage $0 <dir> <files_list>"
	exit 1
fi

# Check file
if [ ! -f $2 ]; then
	echo "Invalid file: $2"
	exit 1
fi

dir=$1
file_list=$2
package_name=$(basename ${dir})
#>&2 echo $package_name

# Magic number :)
NUMBER_OF_FILES=3 # Change this for better determination.

# Process
#Get a number of files that have longest file paths inside the program dir
longest_filepaths=$(grep ${dir} ${file_list} | sed -r -n 's,('${dir}')/(.*),\2,p' | awk '{print length, $0}' | sort -nr | head -${NUMBER_OF_FILES} | awk '{print $2}')
#>&2 echo ${longest_filepaths}

#Use GitHub API to search for those filepaths to find their public repo on internet
userrepos=""

for filepath in ${longest_filepaths}; do \
  sleep 2 # avoid connection refused from Github server
  internet_repos=$(python ./github_filesearch.py ${filepath} | sort | uniq -u);
  userrepos=$(echo ${userrepos} ${internet_repos});
done

# Enhance quality of search by directly searching "package_name" on GitHub
# Only get the first (most relevant) result
userrepo_direct=$(python ./github_search.py repositories ${package_name} | head -1) 
#>&2 echo direct:${userrepo_direct}

# Filter the result: get only the repo that appear in all returned results
# (Since each search with individual file path returns more than one possible repo. 
# The one we are looking for is the one that exist in all the returned results.)
userrepos_filtered=$(for ur in ${userrepos}; do echo ${ur}; done | sort | uniq -c | gawk '$1=='${NUMBER_OF_FILES}'{print $2}')
#>&2 echo filtered:${userrepos_filtered}

# Synchronize those results
# If the result found by direct repository search is also in the list of repos found by file search, it will be the final result.
userrepos_synced=$(echo ${userrepo_direct}; echo ${userrepos_filtered} | sort | uniq -d) 
#>&2 echo synced:${userrepos_synced}

# if no repositories found by the file search
if [ "${userrepos_filtered}" == "" ]; then
  if [ "${userrepo_direct}" != "" ]; then
    # then the result found by direct search will be used.
    echo ${dir},$(./github_latest.py ${userrepo_direct}); 
  fi
# when the result found by direct search does not appear in the list of file search
# all possible results will be printed out. But again, not so certain.
elif [ "${userrepos_synced}" == "" ]; then
#  for userrepo in ${userrepos_filtered}; do \
#    echo ${dir},$(./github_latest.py ${userrepo}); 
#  done
  echo ${dir},"[Need google search]"
else
# Life is beautiful! The repo found by direct search also appears in file search result.
  echo ${dir},$(./github_latest.py ${userrepos_synced}); 
fi 
