#!/bin/bash
os_id=$1
os_version=$2

function installNginxUbuntu {
    apt-get -y update
    apt-get -y install nginx
}

function installNginxCentOS {
    # Add nginx repo
    printf '[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0\nenabled=1' > /etc/yum.repos.d/nginx.repo

    # Install nginx with yum
    yum -y install nginx
}

function installNginxFedora {
    yum -y install nginx git
}

function installNginxDebian {
    apt-get -y update
    apt-get -y install nginx
}

function installNginx {
    case "$os_id" in
        ubuntu)
            installNginxUbuntu
            ;;
        centos)
            installNginxCentOS
            ;;
        fedora)
            installNginxFedora
            ;;
        debian)
            installNginxDebian
            ;;
    esac
}

# Install Nginx
echo "Install Nginx"
installNginx

# Open port 80 for Nginx
echo "Open port 80"
./shell_scripts/os/open_port.sh $os_id $os_version 80