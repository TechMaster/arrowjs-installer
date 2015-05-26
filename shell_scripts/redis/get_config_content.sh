#!/bin/bash
os_id=$1
os_version=$2

# Get config path for redis.conf
config_path=`./shell_scripts/redis/get_config_path.sh $os_id $os_version`

 Get config content
if [ "$config_path" != "0" ]; then
    cat $config_path | sed '/^[\t ]*#/d' | grep .
else
    echo -n ""
fi