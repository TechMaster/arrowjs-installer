#!/bin/bash
os_id=$1
os_version=$2

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
            installPostgresCentOS7
        ;;
    esac
}

function installPostgresUbuntu {
    apt-get install postgresql postgresql-client postgresql-contrib libpq-dev
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

function checkCentOSBaseRepo {
    # Exclude old repo of Postgres
    if [ -f "/etc/yum.repos.d/CentOS-Base.repo" ]; then
        sed -i '/.*exclude=postgresql\*.*/d' /etc/yum.repos.d/CentOS-Base.repo
        sed -i '/\[base\]/a exclude=postgresql\*' /etc/yum.repos.d/CentOS-Base.repo
        sed -i '/\[updates\]/a exclude=postgresql\*' /etc/yum.repos.d/CentOS-Base.repo
        return
    else
        exit
    fi
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

installPostgres
