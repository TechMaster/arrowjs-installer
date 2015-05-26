#!/bin/bash
os_id=$1
os_version=$2

# Get config path for nginx.conf
config_path=`./shell_scripts/nginx/get_config_path.sh $os_id $os_version`

# Get config content
if [ "$config_path" != "0" ]; then
    cat $config_path
else
    echo -n ""
fi