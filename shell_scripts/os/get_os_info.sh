#!/bin/bash
os_id=$1
os_version=$2

function getInfoUbuntu {
    ip=`ip addr| grep inet| head -3| tail -1| awk '{print $2}'| sed 's/...$//'`

    os_name=`lsb_release -a | grep Description | awk  -F":" '{print $2}' | sed 's/...$//'`

    os_architect=`uname -m`

    echo "{\"ip\": \"$ip\", \"os\": \"$os_name\", \"arch\": \"$os_architect\"}"
}

function getInfoCenOS6 {
    ip=`ifconfig | grep inet | awk '{ print $2; }' | awk -F":"  '{print $2}' | head -1`

    os_name=`cat /etc/system-release`

    os_architect=`uname -m`

    echo "{\"ip\": \"$ip\", \"os\": \"$os_name\", \"arch\": \"$os_architect\"}"
}

function getInfoCenOS7 {
    ip=`ip addr|grep inet | head -3 | tail -1 | sed 's/inet\(.* \)\(.* \)\(.* \)\(.* \)\(.* \).*/\1/' | sed 's/ //g' | sed 's/...$//'`

    os_name=`cat /etc/os-release|grep PRETTY_NAME= | head -1 | sed 's/\"//g'`
    os_name=${os_name:12}

    os_architect=`uname -m`

    echo "{\"ip\": \"$ip\", \"os\": \"$os_name\", \"arch\": \"$os_architect\"}"
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
        fedora)
            getInfoCenOS7
            ;;
        debian)
            getInfoCenOS7
            ;;
    esac
}

getOsInfo