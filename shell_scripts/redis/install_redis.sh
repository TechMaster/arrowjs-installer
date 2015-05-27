#!/bin/bash
os_id=$1
os_version=$2

function installRedisUbuntu {
    apt-get -y install redis-server
}

function installRedisCentOS {
    rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    yum --enablerepo=remi,remi-test -y install redis
}

function installRedisFedora {
    rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    yum --enablerepo=remi,remi-test -y install redis
}

function installRedisDebian {
    apt-get -y install redis-server
}

function installRedis {
    case "$os_id" in
        ubuntu)
            installRedisUbuntu
            ;;
        centos)
            installRedisCentOS
            ;;
        fedora)
            installRedisFedora
            ;;
        debian)
            installRedisDebian
            ;;
    esac
}

installRedis