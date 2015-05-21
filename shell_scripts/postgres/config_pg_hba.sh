#!/bin/bash
if [ -z "$1" ]; then
    # Add config with no IP parameter
    sed -i '/^# IPv6 local/i host\tall\t\tall\t\t0.0.0.0/0\t\tmd5' /var/lib/pgsql/9.4/data/pg_hba.conf
else
    # Add config with IP parameter
    sed -i "/^# IPv6 local/i host\tall\t\tall\t\t${1}\t\tmd5" /var/lib/pgsql/9.4/data/pg_hba.conf
fi

# Change all method to md5
sed -i 's/\(local\)\( .* \)\( .* \).*/\1\2  md5/' /var/lib/pgsql/9.4/data/pg_hba.conf
sed -i 's/\(^host\)\( .*all.* \)\( .* \)\( .* \)\(.* \).*/\1\2\3\4\ md5/' /var/lib/pgsql/9.4/data/pg_hba.conf