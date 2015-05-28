#!/bin/bash
os_id=$1
os_version=$2
location=$3
database_name=$4
user=$5
password=$6
project_port=$7

# Check location
project_path=${location%/*}
project_name=${location##/*/}
if [ ! -d "$project_path" ]; then
    echo "Directory is not exist!"
    exit
fi
if [ "$(ls -A $location)" ]; then
    echo "Directory is not empty!"
    exit
fi

# Clone source code form github to websites directory and move to location
cd websites
#git clone https://github.com/quanghuy90hn/arrowjs-core.git
mv arrowjs-core ${project_name}
rm -rf $location
mv $project_name $project_path

# Install node modules
cd $location
#npm install

# Create database
PGPASSWORD="${password}" psql -U ${user} -d postgres -c "CREATE DATABASE ${database_name} OWNER ${user} ENCODING 'UTF-8'"

# Restore database
cd sql
sql_path=`pwd`
file_backup_path="$sql_path/arrowjs.backup"
psql -U postgres $database_name < $file_backup_path

# Config database and project port
cd ../config/env
sed "s/port: *process.env.PORT *|| *3000,/port: process.env.PORT || ${project_port},/" all.js
sed "s/database: *'arrow-js',/database: '${database_name}',/" development.js
sed "s/username: *'postgres',/username: '${user}',/" development.js
sed "s/password: *'secret',/password: '${password}',/" development.js
sed "s/database: *'arrow-js',/database: '${database_name}',/" production.js
sed "s/username: *'postgres',/username: '${user}',/" production.js
sed "s/password: *'secret',/password: '${password}',/" production.js

# Open port for project
echo "Open port ${project_port} for project ${project_name}"
./shell_scripts/os/open_port.sh $os_id $os_version $project_port

# Run website
cd ../..
node server.js