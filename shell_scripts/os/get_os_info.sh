#!/bin/bash
os_id=$1
os_version=$2

function getInfoUbuntu12 {
    IP=`ip addr| grep inet| head -3| tail -1| awk '{print $2}'| sed 's/...$//'`
    echo "$IP"
}

function getInfoUbuntu {
    case "$os_version" in
        12.04)
            getInfoUbuntu12
            ;;
        *)
            getInfoUbuntu12
            ;;
    esac
}

function getInfoCenOS6 {
    IP=`ifconfig | grep inet | awk '{ print $2; }' | awk -F":"  '{print $2}' | head -1`
    echo "$IP"

    osname=`cat /etc/system-release`
    echo "$osname"

    osEdition=`uname -m | grep 64`
    echo "$osEdition"
}

function getInfoCenOS7 {
    IP=`ip addr|grep inet | head -3 | tail -1 | sed 's/inet\(.* \)\(.* \)\(.* \)\(.* \)\(.* \).*/\1/' | sed 's/ //g' | sed 's/...$//'`
    echo "IP address: $IP"

    osname=`cat /etc/os-release|grep PRETTY_NAME=| head -1 | sed 's/\"//g'`
    osname=${osname:12}
    echo "Operating system: $osname"

    osEdition=`uname -m | grep 64`
    echo "Architecture: $osEdition"
}

function getInfoCenOS {
    case "$os_version" in
        6)
            getInfoCenOS6
            ;;
        7)
            getInfoCenOS7
            ;;
        *)
            getInfoCenOS6
            ;;
    esac
}

function getOsInfo {
    case "$os_id" in
        ubuntu)
            getInfoUbuntu
            ;;
        centos)
            getInfoCenOS
            ;;
        *)
            getInfoCenOS
            ;;
    esac
}

getOsInfo