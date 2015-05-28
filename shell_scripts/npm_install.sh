#!/bin/bash
os_id=$1
os_version=$2

case "$os_id" in
    ubuntu)
        npm install
        ;;
    centos)
        sudo npm install
        ;;
    fedora)
        sudo npm install
        ;;
    debian)
        npm install
        ;;
esac
