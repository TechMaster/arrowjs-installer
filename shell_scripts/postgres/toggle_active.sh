#!/bin/bash
os_id=$1
os_version=$2
toggle=$3

postgres_version=`./shell_scripts/postgres/check_version.sh | awk -F"." '{print $1,$2}' OFS='.'`

function activePostgresUbuntu {
    service postgresql $toggle
}

function activePostgresCenOS6 {
    pgservice=`service --status-all | grep postgres`
    spaceIndex=`expr index "$pgservice" " "`
    pgservice=${pgservice:0:spaceIndex}
    service $pgservice $toggle
}

function activePostgresCenOS7 {
    systemctl $toggle postgresql-${postgres_version}
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

function activePostgresFedora {
    service postgresql-${postgres_version} $toggle
}

function activePostgresDebian {
    service postgresql $toggle
}

function activePostgres {
    case "$os_id" in
        ubuntu)
            activePostgresUbuntu
            ;;
        centos)
            activePostgresCenOS
            ;;
        fedora)
            activePostgresFedora
            ;;
        debian)
            activePostgresDebian
            ;;
    esac
}

activePostgres



