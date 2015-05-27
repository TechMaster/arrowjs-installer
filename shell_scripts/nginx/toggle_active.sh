#!/bin/bash
os_id=$1
os_version=$2
toggle=$3

function activeNginxUbuntu {
    service nginx $toggle
}

function activeNginxCenOS6 {
    service nginx $toggle
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

function activeNginxFedora {
    service nginx $toggle
}

function activeNginxDebian {
    service nginx $toggle
}

function activeNginx {
    case "$os_id" in
        ubuntu)
            activeNginxUbuntu
            ;;
        centos)
            activeNginxCenOS
            ;;
        fedora)
            activeNginxFedora
            ;;
        debian)
            activeNginxDebian
            ;;
    esac
}

activeNginx



