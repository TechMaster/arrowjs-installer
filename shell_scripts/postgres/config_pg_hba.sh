#!/bin/bash
os_id=$1
os_version=$2
ip=$3
path="/var/lib/pgsql/9.4/data/pg_hba.conf"

function addIp {
    if [ -z "$ip" ]; then
        # Add config with no IP argument
        sed -i '/^# IPv6 local/i host\tall\t\tall\t\t0.0.0.0/0\t\tmd5' $1
    else
        # Add config with IP argument
        sed -i "/^# IPv6 local/i host\tall\t\tall\t\t${ip}\t\tmd5" $1
    fi
}

function configPostgresPgHba {
    case "$os_id" in
        ubuntu)
            path="/etc/postgresql/9.4/main/pg_hba.conf"
            addIp $path
            ;;
        centos)
            addIp $path
            ;;
        fedora)
            addIp $path
            ;;
        debian)
            path="/etc/postgresql/9.4/main/pg_hba.conf"
            addIp $path
            ;;
    esac

    # Change all method to md5
    #sed -i 's/\(local\)\( .* \)\( .* \).*/\1\2  md5/' $path
    #sed -i 's/\(^host\)\( .*all.* \)\( .* \)\( .* \)\(.* \).*/\1\2\3\4\ md5/' $path
}

configPostgresPgHba