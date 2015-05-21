#!/bin/bash
# Check pm2 installed
pm2=`npm list -g | grep pm2@`

if [ -z "$pm2" ]; then
    echo -n ""
else
    # Get pm2 version
    version=`echo $pm2 | awk -F"@" '{print $2}'`
    echo -n $version
fi


