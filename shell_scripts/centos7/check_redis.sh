#!/bin/bash
# Find redis-* directory with higher version
redis_path=`find / -type d -name 'redis-*' | sort -V | tail -1`
echo "$redis_path"


