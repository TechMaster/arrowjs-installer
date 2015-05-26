#!/bin/bash
os_id=$1
os_version=$2

postgres_version=`./shell_scripts/postgres/check_version.sh | awk -F"." '{print $1,$2}' OFS='.'`
hba_path=""
postgres_path=""

# If file not exists => echo 0
function checkFileExist {
    if [ -f "$1" ]; then
        echo -n " $1 "
    else
        echo -n " 0 "
    fi

    if [ -f "$2" ]; then
        echo -n " $2 "
    else
        echo -n " 0 "
    fi
}

case "$os_id" in
    ubuntu)
        hba_path="/etc/postgresql/${postgres_version}/main/pg_hba.conf"
        postgres_path="/etc/postgresql/${postgres_version}/main/postgresql.conf"
        checkFileExist $hba_path $postgres_path
        ;;
    centos)
        hba_path="/var/lib/pgsql/${postgres_version}/data/pg_hba.conf"
        postgres_path="/var/lib/pgsql/${postgres_version}/data/postgresql.conf"
        checkFileExist $hba_path $postgres_path
        ;;
    fedora)
        hba_path="/var/lib/pgsql/${postgres_version}/data/pg_hba.conf"
        postgres_path="/var/lib/pgsql/${postgres_version}/data/postgresql.conf"
        checkFileExist $hba_path $postgres_path
        ;;
    debian)
        hba_path="/etc/postgresql/${postgres_version}/main/pg_hba.conf"
        postgres_path="/etc/postgresql/${postgres_version}/main/postgresql.conf"
        checkFileExist $hba_path $postgres_path
        ;;
esac