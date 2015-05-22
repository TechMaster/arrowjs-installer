#!/bin/bash
os_id=$1
os_version=$2
port=$3

function openPortUbuntu {
    iptables -I INPUT -p tcp -m tcp --dport ${port} -j ACCEPT
    service iptables save
}

function openPortCenOS6 {
    iptables -I INPUT -p tcp -m tcp --dport ${port} -j ACCEPT
    service iptables save
}

function openPortCenOS7 {
    firewall-cmd --zone=public --add-port=${port}/tcp --permanent
    firewall-cmd --reload
}

function openPortCenOS {
    case "$os_version" in
        6)
            openPortCenOS6
            ;;
        7)
            openPortCenOS7
            ;;
        *)
            openPortCenOS6
            ;;
    esac
}

function openPort {
    case "$os_id" in
        ubuntu)
            openPortUbuntu
            ;;
        centos)
            openPortCenOS
            ;;
        *)
            openPortUbuntu
            ;;
    esac
}

openPort