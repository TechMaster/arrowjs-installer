#!/bin/bash
# Check pm2 installed
pm2=`npm list -g | grep pm2@`

if [ -z "$pm2" ]; then
    echo -n ""
else
    # Check pm2 installed with errors
    pm2_error=`npm list -g | grep pm2@ | grep ERR`

    if [ -z "$pm2_error" ]; then
        # Get pm2 version
        version=`echo $pm2 | awk -F"@" '{print $2}'`
        echo -n $version
    else
        echo -n ""
    fi
fi