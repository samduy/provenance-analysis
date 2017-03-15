#!/bin/bash

# Print all packages that are installed and managed by APT
apt list --installed | sed -nr 's/\// /p'  | awk '{print $1}'
