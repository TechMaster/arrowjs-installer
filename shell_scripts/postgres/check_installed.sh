#!/bin/bash
# Check psql installed
psql=`which psql`

if [ -z "$psql" ]; then
    echo -n ""
else
    # Get psql version
    version=`psql --version`

    if [ -z "$version" ]; then
        echo -n "0.0.0"
    else
        version=`echo $version | awk '{print $3}'`
        echo -n $version
    fi
fi