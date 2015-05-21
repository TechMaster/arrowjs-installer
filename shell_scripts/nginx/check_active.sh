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

function checkNginxActiveFedora21 {
    nginx_active=`service  --status-all | grep nginx | grep running`
}

function checkNginxActiveFedora {
    case "$os_version" in
        21)
            checkNginxActiveFedora21
            ;;
        *)
            checkNginxActiveFedora21
            ;;
    esac
}

function checkNginxActiveDebian8 {
    checkNginxActiveCenOS6
}

function checkNginxActiveDebian {
    case "$os_version" in
        8)
            checkNginxActiveDebian8
            ;;
        *)
            checkNginxActiveDebian8
            ;;
    esac
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
        echo 0
    else
        echo 1
    fi
}
