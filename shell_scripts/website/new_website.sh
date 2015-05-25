#!/bin/bash
os_id=$1
os_version=$2
path=$3
project_name=$4
database_name=$5
running_port=$6

# Clone source code form github
cd $path
git clone https://github.com/quanghuy90hn/arrowjs-core.git

# Rename project
mv arrowjs-core $project_name

# Install node modules
cd $project_name
npm install

# Create database
psql -U postgres -c "CREATE DATABASE ${database_name} OWNER postgres ENCODING 'UTF-8'"

# Restore database
cd sql
sql_path=`pwd`
file_backup_path="$sql_path/arrowjs.backup"
psql -U postgres $database_name < $file_backup_path

# Config database


# Open port for project
#echo "Open port ${port} for project ${project_name}"
#./shell_scripts/os/open_port.sh $os_id $os_version $running_port

# Run website
#node server.js