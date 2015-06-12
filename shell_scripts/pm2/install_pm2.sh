#!/bin/bash
os_id=$1
os_version=$2

case "$os_id" in
    ubuntu)
        sudo npm install -g pm2
        source ~/.profile
        ;;
    centos)
        sudo npm install -g pm2
        source ~/.bash_profile
        ;;
    fedora)
        sudo npm install -g pm2
        source ~/.bash_profile
        ;;
    debian)
        npm install -g pm2
        source ~/.profile
        ;;
esac
