#!/bin/bash
# Check nginx installed
nginx=`which nginx`

if [ -z "$nginx" ]; then
    echo -n ""
else
    echo -n "installed"

    # Get nginx version
    version=`nginx -v`
fi


