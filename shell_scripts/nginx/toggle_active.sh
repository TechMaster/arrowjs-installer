#!/bin/bash
# Start/Stop Nginx with parameter 1
if [ "$1" == "start" ]; then
    systemctl start nginx
else
    systemctl stop nginx
fi