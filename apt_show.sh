#!/bin/bash
sudo /usr/bin/apt-cache show $1| egrep "Package|Version|Architecture|Size|SHA256|SHA1|MD5sum|Homepage|Description-md5|Filename"
