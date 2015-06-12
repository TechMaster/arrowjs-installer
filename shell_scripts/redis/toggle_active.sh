#!/bin/bash
os_id=$1
os_version=$2
toggle=$3

function activeRedisUbuntu {
    service redis-server $toggle
}

function activeRedisCenOS6 {
    service redis $toggle
}

function activeRedisCenOS7 {
    systemctl $toggle redis
}

function activeRedisCenOS {
    case "$os_version" in
        6)
            activeRedisCenOS6
            ;;
        7)
            activeRedisCenOS7
            ;;
        *)
            activeRedisCenOS6
            ;;
    esac
}

function activeRedisFedora {
    service redis $toggle
}

function activeRedisDebian {
    service redis-server $toggle
}

# Active Redis
case "$os_id" in
    ubuntu)
        activeRedisUbuntu
        ;;
    centos)
        activeRedisCenOS
        ;;
    fedora)
        activeRedisFedora
        ;;
    debian)
        activeRedisDebian
        ;;
esac