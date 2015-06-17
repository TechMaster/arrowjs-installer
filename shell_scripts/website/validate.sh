#!/bin/bash
location=$1
use_nginx=$2
file_name=$3

# Analyze location
project_path=${location%/*}
project_name=${location##/*/}

# Check directory exists
if [ ! -d "$project_path" ]; then
    echo "Directory is not exist!"
    exit 127
fi

# Check directory empty
if [[ -d "$location" && "$(ls -A $location)" ]]; then
    echo "Directory is not empty!"
    exit 128
fi

if [ ! -z "$use_nginx" ]; then
    if [ -f "/etc/nginx/conf.d/${file_name}" ]; then
        echo "File config already exist"
        exit 129
    fi
fi

echo ""