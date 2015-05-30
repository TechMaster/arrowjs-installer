#!/bin/bash
os_id=$1
os_version=$2
project_name=$3
toggle=$4

if [ "$toggle" == "start" ]; then
    pm2 start server.js --name "${project_name}" -i max
else
    pm2 $toggle $project_name
fi