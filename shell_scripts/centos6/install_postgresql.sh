#!/bin/bash
# Install pgdg-centos94-9.4-1.noarch.rpm"
if [ $1 == "64" ]
    rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
else
    rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-6-i386/pgdg-centos94-9.4-1.noarch.rpm
fi

# Install Postgres via yum
yum update
yum -y install postgresql94-server postgresql94-contrib

# Initialize database for first time use
service postgresql-9.4 initdb
	
# Enable Postgres when server start
chkconfig postgresql-9.4 on

