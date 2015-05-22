#!/bin/bash
os_id=$1
os_version=$2

function getIPAddressUbuntu {
    IP=`ip addr| grep inet| head -3| tail -1| awk '{print $2}'| sed 's/...$//'`
    echo -n $IP
}

function getIPAddressCenOS6 {
    IP=`ifconfig | grep inet | awk '{ print $2; }' | awk -F":"  '{print $2}' | head -1`
    echo -n $IP
}

function getIPAddressCenOS7 {
    IP=`ip addr|grep inet | head -3 | tail -1 | sed 's/inet\(.* \)\(.* \)\(.* \)\(.* \)\(.* \).*/\1/' | sed 's/ //g' | sed 's/...$//'`
    echo -n $IP
}

function getIPAddressCenOS {
    case "$os_version" in
        6)
            getIPAddressCenOS6
            ;;
        7)
            getIPAddressCenOS7
            ;;
        *)
            getIPAddressCenOS6
            ;;
    esac
}

function getIPAddress {
    case "$os_id" in
        ubuntu)
            getIPAddressUbuntu
            ;;
        centos)
            getIPAddressCenOS
            ;;
        fedora)
            getIPAddressCenOS7
            ;;
        debian)
            getIPAddressCenOS7
            ;;
    esac
}

getIPAddress