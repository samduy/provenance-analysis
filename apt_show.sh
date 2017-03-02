#!/bin/bash

# Show detail information of a package that managed by APT

sudo /usr/bin/apt-cache show $1| egrep "Package|Version|Architecture|Size|SHA256|SHA1|MD5sum|Homepage|Description-md5|Filename"
