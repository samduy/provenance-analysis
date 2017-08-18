#!/bin/bash

# Check argument
if [ ! $# -eq 2 ]; then
	>&2 echo "Usage $0 <dir> <files_list>"
	exit 1
fi

# Check file
if [ ! -f $2 ]; then
	>&2 echo "Invalid file: $2"
	exit 1
fi

dir=$1
file_list=$2
package_name=$(basename ${dir})
>&3 echo package:$package_name

# Magic number :)
NUMBER_OF_FILES=3 # Change this for better determination.

# Process
#Get a number of files that have longest file paths inside the program dir
longest_filepaths=$(grep ${dir} ${file_list} | sed -r -n 's,('${dir}')/(.*),\2,p' | awk '{print length, $0}' | sort -nr | head -${NUMBER_OF_FILES} | awk '{print $2}')
>&3 echo longest:${longest_filepaths}

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
>&3 echo direct:${userrepo_direct}

# Filter the result: get only the repo that appear in all returned results
# (Since each search with individual file path returns more than one possible repo. 
# The one we are looking for is the one that exist in all the returned results.)
userrepos_filtered=$(for ur in ${userrepos}; do echo ${ur}; done | sort | uniq -c | gawk '$1=='${NUMBER_OF_FILES}'{print $2}')
>&3 echo filtered:${userrepos_filtered}

# Synchronize those results
# If the result found by direct repository search is also in the list of repos found by file search, it will be the final result.
userrepos_synced=$(echo ${userrepo_direct} ${userrepos_filtered} | fmt -w1 | sort | uniq -d)
>&3 echo synced:${userrepos_synced}

# The result is reliable if: repo found by repo-search also appears in file-search results.
>&3 echo ${dir}:${userrepos_synced}
if [ "${userrepos_synced}" != "" ]; then
  echo ${dir},$(./github_latest.py ${userrepos_synced}); 
fi 
