#!/bin/bash
os_id=$1
os_version=$2
location=$3
database_name=$4
user=$5
password=$6
project_port=$7
use_nginx=$8

# Analyze location
project_path=${location%/*}
project_name=${location##/*/}

## Check directory exists
#if [ ! -d "$project_path" ]; then
#    echo "Directory is not exist!"
#    exit 127
#fi
#
## Check directory empty
#if [[ -d "$location" && "$(ls -A $location)" ]]; then
#    echo "Directory is not empty!"
#    exit 128
#fi

# Open port for project if not use Nginx
if [ -z "$use_nginx" ]; then
    echo "Open port ${project_port}"
    ./shell_scripts/os/open_port.sh $os_id $os_version $project_port
fi

# Check Redis active
check_redis_active=`./shell_scripts/redis/check_active.sh $os_id $os_version`
if [ -z "$check_redis_active" ]; then
    echo "Start Redis service"
    ./shell_scripts/redis/toggle_active.sh $os_id $os_version start
fi

# Check Postgres active
check_pg_active=`./shell_scripts/postgres/check_active.sh $os_id $os_version`
if [ -z "$check_pg_active" ]; then
    echo "Start Postgresql service"
    ./shell_scripts/postgres/toggle_active.sh $os_id $os_version start
fi

# Clone source code form github to websites directory and move to location
cd websites
echo "Clone source code form Github"
#todo: git clone https://github.com/quanghuy90hn/arrowjs-core.git
mv arrowjs-core ${project_name}
rm -rf $location
mv $project_name $project_path

# Install node modules
echo "Install node modules"
cd $location
case "$os_id" in
    ubuntu)
        sudo npm install
        ;;
    centos)
        sudo npm install
        ;;
    fedora)
        sudo npm install
        ;;
    debian)
        npm install
        ;;
esac

# Create database
echo "Create database ${database_name}"
PGPASSWORD="$password" psql -U $user -d postgres -c "CREATE DATABASE ${database_name} OWNER ${user} ENCODING 'UTF-8'"

# Restore database
echo "Restore database"
cd sql
sql_path=`pwd`
file_backup_path="$sql_path/arrowjs.sql"
PGPASSWORD="$password" psql -U $user -d $database_name < $file_backup_path

# Config Project port, Redis prefix and database connection
echo "Config website"
cd ../config/env
sed -i "s/redis_prefix:.*/redis_prefix: '${project_name}_',/" all.js
sed -i "s/port: *process.env.PORT *|| *3000,/port: process.env.PORT || ${project_port},/" all.js
sed -i "s/database: *'arrowjs',/database: '${database_name}',/" development.js
sed -i "s/username: *'postgres',/username: '${user}',/" development.js
sed -i "s/password: *'secret',/password: '${password}',/" development.js
sed -i "s/database: *'arrowjs',/database: '${database_name}',/" production.js
sed -i "s/username: *'postgres',/username: '${user}',/" production.js
sed -i "s/password: *'secret',/password: '${password}',/" production.js

# Run website
echo "Start website with PM2"
cd ../..
chmod -R 755 public
case "$os_id" in
    ubuntu)
        source ~/.profile
        ;;
    centos)
        source ~/.bash_profile
        ;;
    fedora)
        source ~/.bash_profile
        ;;
    debian)
        source ~/.profile
        ;;
esac
pm2 start server.js --name "${project_name}" -i 0