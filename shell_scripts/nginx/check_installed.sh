#!/bin/bash
# Check nginx installed
nginx=`which nginx`

if [ -z "$nginx" ]; then
    echo -n ""
else
    # Get nginx version
    version=`nginx -v`

    if [ -z "$version" ]; then
        echo -n "0.0.0"
    else
        version=`echo $version | awk -F"/" '{print $2}'`
        echo -n ${version:18}
    fi
fi


