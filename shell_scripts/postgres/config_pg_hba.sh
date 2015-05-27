#!/bin/bash
os_id=$1
os_version=$2
postgres_password=$3
ip=$4

config_path=`./shell_scripts/postgres/get_config_path.sh $os_id $os_version`
path=`echo $config_path | awk '{print $1}'`

# Change local method to trust
sed -i 's/\(local\)\( .* \)\( .* \).*/\1\2  trust/' $path

# Change Postgres user password
./shell_scripts/postgres/toggle_active.sh $os_id $os_version start
psql -U postgres -c "ALTER USER postgres WITH PASSWORD '${postgres_password}'"
./shell_scripts/postgres/toggle_active.sh $os_id $os_version stop

# Change local method to md5
sed -i 's/\(local\)\( .* \)\( .* \).*/\1\2  md5/' $path

# Change all method to md5
sed -i 's/\(^host\)\( .*all.* \)\( .* \)\( .* \)\(.* \).*/\1\2\3\4\ md5/' $path

# Add rules with IP argument
if [ -z "$ip" ]; then
    # Add config with no IP argument
    sed -i '/^# IPv6 local/i host\tall\t\tall\t\t0.0.0.0/0\t\tmd5' $path
else
    # Add config with IP argument
    sed -i "/^# IPv6 local/i host\tall\t\tall\t\t${ip}\t\tmd5" $path
fi
