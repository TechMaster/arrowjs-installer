#!/bin/bash
os_id=$1
os_version=$2

function installNginxUbuntu {
    # Install Nginx with apt-get
    apt-get -y update
    apt-get -y install nginx
}

function installNginxCentOS {
    # Add Nginx repo
    printf '[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0\nenabled=1' > /etc/yum.repos.d/nginx.repo

    # Install Nginx with yum
    yum -y install nginx

    # Enable Nginx when server boot
    chkconfig redis on
}

function installNginxFedora {
    # Install Nginx with yum
    yum -y install nginx git

    # Enable Nginx when server boot
    chkconfig redis on
}

function installNginxDebian {
    # Install Nginx with apt-get
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