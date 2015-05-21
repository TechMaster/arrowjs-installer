#!/bin/bash
os_id=$1
os_version=$2

function installPostgresUbuntu1204 {
    sudo apt-get update
    sudo apt-get install postgresql
}

function installPostgresUbuntu1504 {
    sudo apt-get update
    sudo apt-get install postgresql postgresql-contrib
}

function installPostgresUbuntu {
    case "$os_version" in
        1204)
            installPostgresUbuntu1204
            ;;
        1504)
            installPostgresUbuntu1504
            ;;
        *)
            installPostgresUbuntu1504
            ;;
    esac
}

function checkCentOSBaseRepo {
    # Exclude old repo of Postgres on CentOS
    sed -i '/.*exclude=postgresql\*.*/d' /etc/yum.repos.d/CentOS-Base.repo
    sed -i '/\[base\]/a exclude=postgresql\*' /etc/yum.repos.d/CentOS-Base.repo
    sed -i '/\[updates\]/a exclude=postgresql\*' /etc/yum.repos.d/CentOS-Base.repo
}

function installPostgresCentOS6 {
    checkCentOSBaseRepo

    os64bit=`uname -m | grep 64`

    if [ ! -z "$os64bit" ]; then
        rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
    else
        rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-6-i386/pgdg-centos94-9.4-1.noarch.rpm
    fi

    yum update
    yum -y install postgresql94-server postgresql94-contrib

    service postgresql-9.4 initdb

    chkconfig postgresql-9.4 on
}

function installPostgresCentOS7 {
    checkCentOSBaseRepo

    if ! rpm -qa | grep pgdg-centos94-9.4-1
    then
        echo "Install pgdg-centos94-9.4-1.noarch.rpm"
        rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
    else
        echo "pgdg-centos94-9.4-1.noarch.rpm is already installed. Skip"
    fi

    yum update

    if ! yum list installed | grep postgresql94-server
    then
        echo "Install postgresql94-server"
        yum -y install postgresql94-server
    else
        echo "postgresql94-server is already installed. Skip"
    fi

    if ! yum list installed | grep postgresql94
    then
        echo "Install postgresql94"
        yum -y install postgresql94
    else
        echo "postgresql94 is already installed. Skip"
    fi

    if ! yum list installed | grep postgresql94-contrib
    then
        echo "Install postgresql94-contrib"
        yum -y install postgresql94-contrib
    else
        echo "postgresql94-contrib is already installed. Skip"
    fi

    echo "Initialize database for first time use"
    /usr/pgsql-9.4/bin/postgresql94-setup initdb
}

function installPostgresCentOS {
    # Install Postgres with specific OS version of CentOS
    case "$os_version" in
        6)
            installPostgresCentOS6
            ;;
        7)
            installPostgresCentOS7
            ;;
        *)
            installPostgresCentOS6
            ;;
    esac
}

function checkFedoraBaseRepo {
    # Exclude old repo of Postgres on Fedora
    sed -i '/.*exclude=postgresql\*.*/d' /etc/yum.repos.d/fedora.repo
    sed -i '/\[fedora\]/a exclude=postgresql\*' /etc/yum.repos.d/fedora.repo
    sed -i '/.*exclude=postgresql\*.*/d' /etc/yum.repos.d/fedora-updates.repo
    sed -i '/\[updates\]/a exclude=postgresql\*' /etc/yum.repos.d/fedora-updates.repo
}

function installPostgresFedora21 {
    checkFedoraBaseRepo

    rpm -Uvh http://yum.postgresql.org/9.4/fedora/fedora-21-x86_64/pgdg-fedora94-9.4-2.noarch.rpm
    yum update
    yum -y install postgresql94-server postgresql94-contrib
}

function installPostgresFedora {
    case "$os_version" in
        21)
            installPostgresFedora21
            ;;
        *)
            installPostgresFedora21
            ;;
    esac
}

function installPostgresDebian8 {
    printf "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" > /etc/apt/sources.list.d/pgdg.list

    wget https://www.postgresql.org/media/keys/ACCC4CF8.asc
    apt-key add ACCC4CF8.asc
    apt-get update
    apt-get install postgresql
}

function installPostgresDebian {
    case "$os_version" in
        8)
            installPostgresDebian8
            ;;
        *)
            installPostgresDebian8
            ;;
    esac
}

function installPostgres {
    # Install Postgres with specific OS
    case "$os_id" in
        ubuntu)
            installPostgresUbuntu
            ;;
        centos)
            installPostgresCentOS
            ;;
        fedora)
            installPostgresFedora
            ;;
        debian)
            installPostgresDebian
            ;;
    esac
}

installPostgres