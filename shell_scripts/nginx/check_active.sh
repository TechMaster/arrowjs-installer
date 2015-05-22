#!/bin/bash
os_id=$1
os_version=$2

function checkNginxActiveUbuntu {
    nginx_active=`service nginx status | awk -F":" '{print $2}'`
}

function checkNginxActiveCenOS6 {
    nginx_active=`service  --status-all | grep nginx | grep running`
}

function checkNginxActiveCenOS7 {
    nginx_active=`systemctl --state=active | grep nginx`
}

function checkNginxActiveCenOS {
    case "$os_version" in
        6)
            checkNginxActiveCenOS6
            ;;
        7)
            checkNginxActiveCenOS7
            ;;
        *)
            checkNginxActiveCenOS6
            ;;
    esac
}

function checkNginxActiveFedora {
    nginx_active=`service  --status-all | grep nginx | grep running`
}

function checkNginxActiveDebian {
    nginx_active=`service  --status-all | grep nginx | grep running`
}

function checkNginxActive {
    case "$os_id" in
        ubuntu)
            checkNginxActiveUbuntu
            ;;
        centos)
            checkNginxActiveCenOS
            ;;
        fedora)
            checkNginxActiveFedora
            ;;
        debian)
            checkNginxActiveDebian
            ;;
    esac

    if [ -z "$nginx_active" ]; then
        echo ""
    else
        echo "active"
    fi
}
