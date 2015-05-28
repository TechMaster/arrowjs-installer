#!/bin/bash
os_id=$1
os_version=$2
ip=$3

config_path=`./shell_scripts/postgres/get_config_path.sh $os_id $os_version`
path=`echo $config_path | awk '{print $2}'`

function configListenAddresses {
    sed -i "s/\(^.*listen_addresses\)\([\t ]*=[\t ]*\)\([^\t]*\)\([\t ]*\)\(.*\)/listen_addresses\2'${ip}'\4\5/" $1
}

configListenAddresses $path

