#!/bin/bash
os_id=$1
os_version=$2
ip=$3
path="/var/lib/pgsql/9.4/data/postgresql.conf"

function configListenAddresses {
    sed -i "s/\(^.*listen_addresses\)\([\t ]*=[\t ]*\)\([^\t]*\)\([\t ]*\)\(.*\)/listen_addresses\2'${ip}'\4\5/" $1
}

function configPostgres {
    case "$os_id" in
        ubuntu)
            configListenAddresses $path
            ;;
        centos)
            configListenAddresses $path
            ;;
        fedora)
            configListenAddresses $path
            ;;
        debian)
            path="/etc/postgresql/9.4/main/postgresql.conf"
            configListenAddresses $path
            ;;
    esac
}

configPostgres
