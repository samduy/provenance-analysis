# Program: PROCERATO - Program Provenance Analysis
# Author: Duy KHUONG <khuong@eurecom.fr>
# setting.mk

APT_PKGNAMES=apt-pkgnames.list
APT_LST=apt.list
APT_SO_LST=apt_sorted.list
ALL_FILES_LST=all_files.list
INTERESTING_LST=interesting.list
INTERESTING_DIRS_LST=interesting_dirs.list
FILES_INFO=files_info.dat
PROGRAMS_INFO=programs_info.dat
INTERNET_INFO=internet_info.dat

# File extensions to be scanned
# .XPI: Firefox add-on file extension (applicable for Linux?)
SCAN_TYPES=(so|sh|py|pyc|rb|jar|apk|php|js|pl|xpi)

# Specify directories to scan
ifdef DIR
SCAN_DIRS=$(DIR)
else
SCAN_DIRS="/usr/lib /usr/share /var"
#SCAN_DIRS="/opt"
endif

# PIP installed packages directory
# It can be shown by:
# pip show -f <any_installed_pakage> | grep Location 
PIP_DIR=/usr/local/lib/python2.7/dist-packages

# Firefox add-on directories
MOZ_EXT_DIR=/usr/lib/mozilla/extentions
MOZ_PLG_DIR=/usr/lib/mozilla/plugins

# Chrome extension directory
