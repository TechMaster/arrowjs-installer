#!/bin/bash
os_id=$1
os_version=$2
toggle=$3

function activeNginxCenOS6 {
    nginx_service=`service  --status-all | grep nginx`
    spaceIndex=`expr index "$nginx_service" " "`
    nginx_service=${nginx_service:0:spaceIndex}
    service $nginx_service $toggle
}

function activeNginxCenOS7 {
    systemctl $toggle nginx
}

function activeNginxCenOS {
    case "$os_version" in
        6)
            activeNginxCenOS6
            ;;
        7)
            activeNginxCenOS7
            ;;
        *)
            activeNginxCenOS6
            ;;
    esac
}

function activeNginx {
    case "$os_id" in
        ubuntu)
            service nginx $toggle
            ;;
        centos)
            activeNginxCenOS
            ;;
    esac
}

activeNginx



