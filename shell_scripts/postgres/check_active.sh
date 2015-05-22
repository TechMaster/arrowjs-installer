#!/bin/bash
os_id=$1
os_version=$2

function checkPGActiveUbuntu {
    pg_active=`service postgresql status | awk -F":" '{print $2}'`
}

function checkPGActiveCenOS6 {
    pg_active=`service  --status-all | grep postgres | grep running`
}

function checkPGActiveCenOS7 {
    pg_active=`systemctl --state=active | grep postgresql`
}

function checkPGActiveCenOS {
    case "$os_version" in
        6)
            checkPGActiveCenOS6
            ;;
        7)
            checkPGActiveCenOS7
            ;;
        *)
            checkPGActiveCenOS6
            ;;
    esac
}

function checkPGActiveFedora21 {
    pg_active=`service  --status-all | grep postgres | grep running`
}

function checkPGActiveFedora {
    case "$os_version" in
        21)
            checkPGActiveFedora21
            ;;
        *)
            checkPGActiveFedora21
            ;;
    esac
}

function checkPGActiveDebian8 {
    pg_active=`service  --status-all | grep postgres | grep running`
}

function checkPGActiveDebian {
    case "$os_version" in
        8)
            checkPGActiveDebian8
            ;;
        *)
            checkPGActiveDebian8
            ;;
    esac
}

function checkPGActive {
    case "$os_id" in
        ubuntu)
            checkPGActiveUbuntu
            ;;
        centos)
            checkPGActiveCenOS
            ;;
        fedora)
            checkPGActiveFedora
            ;;
        debian)
            checkPGActiveDebian
            ;;
    esac

    if [ -z "$pg_active" ]; then
        echo 0
    else
        echo 1
    fi
}

checkPGActive