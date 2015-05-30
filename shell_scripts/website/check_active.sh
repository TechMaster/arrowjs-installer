#!/bin/bash
os_id=$1
os_version=$2
project_name=$3

project_active=`pm2 show $project_name | grep [PM2][WARN]`

if [ -z "$project_active" ]; then
    echo -n "active"
else
    echo -n ""
fi