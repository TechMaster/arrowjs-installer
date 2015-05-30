#!/bin/bash
os_id=$1
os_version=$2

case "$os_id" in
    ubuntu)
        sudo npm install -g pm2
        ;;
    centos)
        sudo npm install -g pm2
        ;;
    fedora)
        sudo npm install -g pm2
        ;;
    debian)
        npm install -g pm2
        ;;
esac
