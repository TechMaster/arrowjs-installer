#!/bin/bash
os_id=$1
os_version=$2

function getInfoUbuntu12 {
    IP=`ip addr| grep inet| head -3| tail -1| awk '{print $2}'| sed 's/...$//'`
    echo -n "$IP"
}

function getInfoUbuntu {
    if [ -z "$os_version" ]
    then
        echo "call function get osname and osversion"
        exit
    else
        echo ""
    fi

    case "$1" in
        12.04)
            getInfoUbuntu12
        ;;
        *)
            echo  "default"
        ;;
    esac
}

function getInfoCenOS6 {
    IP=`ifconfig | grep inet | awk '{ print $2; }' | awk -F":"  '{print $2}' | head -1`
    echo -n "$IP"

    osname=`cat /etc/system-release`
    echo -n "$osname"

    osEdition=`uname -m | grep 64`
    echo -n "$osEdition"
}

function getInfoCenOS7 {
    IP=`ip addr|grep inet | head -3 | tail -1 | sed 's/inet\(.* \)\(.* \)\(.* \)\(.* \)\(.* \).*/\1/' | sed 's/ //g' | sed 's/...$//'`
    echo "IP address: $IP"

    osname=`cat /etc/os-release|grep PRETTY_NAME=| head -1 | sed 's/\"//g'`
    osname=${osname:12}
    echo "Operating system: $osname"

    osEdition=`uname -m | grep 64`
    echo -n "Architecture: $osEdition"
}

function getInfoCenOS {
if [ -z "$os_version" ]
then
    echo "call funciton get osname and osversion"
    exit
else
    echo ""
fi

case "$os_version" in
    6)
        getInfoCenOS6
    ;;
    7)
        getInfoCenOS7
    ;;
    *)
        echo "default"
    ;;
esac
}

function getOsInfo {
    if [ -z "$os_id" ]
    then
        echo "call funciton get os_id and os_version"
        exit
    else
        echo ""
    fi

    case "$os_id" in
        ubuntu)
            getInfoUbuntu
        ;;
        centos)
            getInfoCenOS
        ;;
        *)
            echo "default"
        ;;
    esac
}

getOsInfo