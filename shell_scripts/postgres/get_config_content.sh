#!/bin/bash
os_id=$1
os_version=$2
file=$3

# Get default config path for postgresql.conf
config_path=`./shell_scripts/postgres/get_config_path.sh $os_id $os_version`
path=`echo $config_path | awk '{print $2}'`

if [ "$file" == "1" ]; then
    # Get config path for pg_hba.conf
    path=`echo $config_path | awk '{print $1}'`
fi

# Get config content
if [ "$path" != "0" ]; then
    cat $path | sed '/^[\t ]*#/d' | grep .
else
    echo -n ""
fi