#!/bin/bash
os_id=$1
os_version=$2
toggle=$3

function activePostgresCenOS6 {
    pgservice=`service  --status-all| grep postgres`
    spaceIndex=`expr index "$pgservice" " "`
    pgservice=${pgservice:0:spaceIndex}
    service $pgservice $toggle
}

function activePostgresCenOS7 {
    systemctl $toggle postgresql-9.4
}

function activePostgresCenOS {
    case "$os_version" in
        6)
            activePostgresCenOS6
            ;;
        7)
            activePostgresCenOS7
            ;;
        *)
            activePostgresCenOS6
            ;;
    esac
}

function activePostgres {
    case "$os_id" in
        ubuntu)
            service postgresql $toggle
            ;;
        centos)
            activePostgresCenOS
            ;;
    esac
}

activePostgres



