#!/bin/bash
os_id=$1
os_version=$2

function installPostgresUbuntu1204 {
    apt-get -y update
    apt-get -y install postgresql
}

function installPostgresUbuntu1504 {
    apt-get -y update
    apt-get -y install postgresql postgresql-contrib
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

    yum -y update
    yum install -y postgresql-server postgresql-contrib

    echo "Initialize database for first time use"
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

    yum -y update

    yum install -y postgresql-server postgresql-contrib

    echo "Initialize database for first time use"
    /usr/pgsql-9.4/bin/postgresql94-setup initdb

    systemctl enable postgresql-9.4.service
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

function installPostgresFedora {
    # Exclude old repo of Postgres on Fedora
    sed -i '/.*exclude=postgresql\*.*/d' /etc/yum.repos.d/fedora.repo
    sed -i '/\[fedora\]/a exclude=postgresql\*' /etc/yum.repos.d/fedora.repo
    sed -i '/.*exclude=postgresql\*.*/d' /etc/yum.repos.d/fedora-updates.repo
    sed -i '/\[updates\]/a exclude=postgresql\*' /etc/yum.repos.d/fedora-updates.repo

    rpm -Uvh http://yum.postgresql.org/9.4/fedora/fedora-21-x86_64/pgdg-fedora94-9.4-2.noarch.rpm
    yum -y update
    yum -y install postgresql-server postgresql-contrib

    echo "Initialize database for first time use"
    /usr/pgsql-9.4/bin/postgresql94-setup initdb

    chkconfig postgresql-9.4 on
}

function installPostgresDebian {
    printf "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" > /etc/apt/sources.list.d/pgdg.list

    wget https://www.postgresql.org/media/keys/ACCC4CF8.asc
    apt-key add ACCC4CF8.asc
    apt-get -y update
    apt-get -y install postgresql
}

function installPostgres {
    echo "Update yum packages"

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

# Install postgres
echo "Install Postgres"
installPostgres

# Open port 5432 for postgres
echo "Open port 5432 for Postgres"
./shell_scripts/os/open_port.sh $os_id $os_version 5432