#!/bin/bash
os_id=$1
os_version=$2
path=$3
project_name=$4
port=$5
database_name=$6

# Clone source code form github
cd $path
git clone https://github.com/quanghuy90hn/arrowjs-core.git

# Rename project
mv arrowjs-core $project_name

# Install node modules
cd $project_name
npm install

# Restore database
cd sql
sql_path=`pwd`
file_backup_path="$sql_path/arrowjs.backup"
psql --username=postgres $database_name < file_backup_path

# Config database

# Open port for project
#echo "Open port ${port} for project ${project_name}"
#./shell_scripts/os/open_port.sh $os_id $os_version $port

# Run website
#node server.js