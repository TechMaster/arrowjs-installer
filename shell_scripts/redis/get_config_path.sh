#!/bin/bash
os_id=$1
os_version=$2

# If file not exists => echo 0
function checkFileExist {
    if [ -f "$1" ]; then
        echo -n "$1"
    else
        echo -n "0"
    fi
}

case "$os_id" in
    ubuntu)
        path="/etc/redis/redis.conf"
        checkFileExist $path
        ;;
    centos)
        path="/etc/redis.conf"
        checkFileExist $path
        ;;
    fedora)
        path="/etc/redis.conf"
        checkFileExist $path
        ;;
    debian)
        path="/etc/redis/redis.conf"
        checkFileExist $path
        ;;
esac