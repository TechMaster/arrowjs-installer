#!/bin/bash
os_id=$1
os_version=$2

function getIPAddressUbuntu {
    ip=`ip addr | grep inet | head -3 | tail -1 | awk '{print $2}' | sed 's/...$//'`
    echo -n $ip
}

function getIPAddressCenOS6 {
    ip=`ifconfig | grep inet | awk '{ print $2; }' | awk -F":"  '{print $2}' | head -1`
    echo -n $ip
}

function getIPAddressCenOS7 {
    ip=`ip addr | grep inet | head -3 | tail -1 | awk '{print $2}' | sed 's/...$//'`
    echo -n $ip
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