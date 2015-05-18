#!/bin/bash
psql=`which psql`

if [ -z "$psql" ]; then
    echo -n ""
else
    version=`psql --version`

    if [ -z "$version" ]; then
        echo -n "0.0.0"
    else
        echo -n ${version:18}
    fi
fi