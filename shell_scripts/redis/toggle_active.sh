#!/bin/bash
# Get Redis path from parameter 1
path="$1/src/"

# Start/Stop Redis with parameter 2
if [ "$2" == "start" ]; then
    ${path}redis-server --daemonize yes
else
    ${path}redis-cli shutdown
fi