#!/bin/bash
# Check psql installed
psql=`which psql`

if [ -z "$psql" ]; then
    echo -n ""
else
    version=`./shell_scripts/postgres/check_version.sh`
    echo -n $version
fi