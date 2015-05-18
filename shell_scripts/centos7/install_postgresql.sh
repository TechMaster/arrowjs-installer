#!/bin/bash
# Exclude Old Postgres from Base repo
if [ -f "/etc/yum.repos.d/CentOS-Base.repo" ]
then
    sed -i '/.*exclude=postgresql\*.*/d' /etc/yum.repos.d/CentOS-Base.repo
    sed -i '/\[base\]/a exclude=postgresql\*' /etc/yum.repos.d/CentOS-Base.repo
    sed -i '/\[updates\]/a exclude=postgresql\*' /etc/yum.repos.d/CentOS-Base.repo
fi

# Install pgdg-centos94-9.4-1.noarch.rpm"
if ! rpm -qa | grep pgdg-centos94-9.4-1 
then
    rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
fi

# Update yum
yum -y update

# Install postgresql94-server
if ! yum list installed	| grep postgresql94-server 
then
    yum -y install postgresql94-server
fi

# Install postgresql94
if ! yum list installed	| grep postgresql94
then 
    yum -y install postgresql94
fi

# Install postgresql94-contrib
if ! yum list installed | grep postgresql94-contrib
then
    yum -y install postgresql94-contrib
fi
