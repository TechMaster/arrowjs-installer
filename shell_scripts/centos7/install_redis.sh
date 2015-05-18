#!/bin/bash
redis_version="3.0.1"

# Check required packages
function checkIfCommandExist {
    command -v $1 >/dev/null 2>&1 || {
        echo 0
        return
    }
    echo 1
}

# Install gcc 
if [ $(checkIfCommandExist gcc) -eq 0 ]; then
    yum install gcc -y &> /dev/null
fi

# Install cc
if [ $(checkIfCommandExist cc) -eq 0 ]; then
    yum install cc -y &> /dev/null
fi

# Install redis 3.0.0
cd ~
if [ ! -f redis-${redis_version}.tar.gz ]; then
    wget http://download.redis.io/releases/redis-${redis_version}.tar.gz
fi

if [ ! -d redis-${redis_version} ] && [ -f redis-${redis_version}.tar.gz ]; then
    tar xzf redis-${redis_version}.tar.gz
    cd redis-${redis_version}
    make
fi

# Remove unused files
cd ~
rm -rf redis-${redis_version}.tar.gz

# Get install path
path=`pwd`
echo $path
