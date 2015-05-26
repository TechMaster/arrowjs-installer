#!/bin/bash
os_id=$1
os_version=$2

function checkRedisActiveUbuntu {
    check=`service redis-server status | awk -F"not" '{print $2}'`
    if [[ -z "$check" ]] ; then
         redis_active="running"
    fi
}

function checkRedisActiveCenOS6 {
    redis_active=`service  --status-all | grep redis | grep running`
}

function checkRedisActiveCenOS7 {
    redis_active=`systemctl --state=active | grep redis`
}

function checkRedisActiveCenOS {
    case "$os_version" in
        6)
            checkRedisActiveCenOS6
            ;;
        7)
            checkRedisActiveCenOS7
            ;;
        *)
            checkRedisActiveCenOS6
            ;;
    esac
}

function checkRedisActiveFedora {
    redis_active=`service  --status-all | grep redis | grep running`
}

function checkRedisActiveDebian {
    check=`service redis status | grep inactive`
    if [ -z "$check" ]; then
        redis_active="active"
    fi
}

function checkRedisActive {
    case "$os_id" in
        ubuntu)
            checkRedisActiveUbuntu
            ;;
        centos)
            checkRedisActiveCenOS
            ;;
        fedora)
            checkRedisActiveFedora
            ;;
        debian)
            checkRedisActiveDebian
            ;;
    esac

    if [ -z "$redis_active" ]; then
        echo -n ""
    else
        echo -n "active"
    fi
}

checkRedisActive