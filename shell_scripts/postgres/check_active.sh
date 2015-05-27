#!/bin/bash
os_id=$1
os_version=$2

postgres_version=`./shell_scripts/postgres/check_version.sh | awk -F"." '{print $1,$2}' OFS='.'`

function checkPGActiveUbuntu {
    check=`service postgresql status | grep inactive`
    if [ -z "$check" ]; then
        pg_active="active"
    fi
}

function checkPGActiveCenOS6 {
    pg_active=`service --status-all | grep postgres | grep running`
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

function checkPGActiveFedora {
    pg_active=`service postgresql-${postgres_version} status | grep running`
}

function checkPGActiveDebian {
    check=`service postgresql status | grep inactive`
    if [ -z "$check" ]; then
        pg_active="active"
    fi
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
        echo -n ""
    else
        echo -n "active"
    fi
}

checkPGActive