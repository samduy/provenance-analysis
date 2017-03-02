#!/bin/bash

# List up all files that are installed by all packages that managed by APT

cat apt.list | while read line; do dpkg-query -L $line; done | grep "usr/lib/*."
