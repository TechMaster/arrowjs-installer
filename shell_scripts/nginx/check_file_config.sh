#!/bin/bash
# Check file config exists
if [ -f "/etc/nginx/conf.d/${1}.conf" ]; then
    echo "exists"
else
    echo ""
fi


