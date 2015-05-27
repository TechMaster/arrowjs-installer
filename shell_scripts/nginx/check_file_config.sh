#!/bin/bash
# Check file config exists
if [ -f "/etc/nginx/conf.d/${1}.conf" ]; then
    echo -n "exists"
else
    echo -n ""
fi


