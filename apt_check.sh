#!/bin/bash

# List all current installed packages that managed by APT

echo "package_name,installed_version,architecture,latest_version"
apt list --installed | sed -nr 's_(.*)/(.*) (.*) (.*) (.*)upgradable to: (.*)]_\1,\3,\4,\6_p'
