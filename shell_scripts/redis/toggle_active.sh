#!/bin/bash
path="$1/src/"
if [ "$2" == "start" ]; then
    ${path}redis-server > /dev/null &
else
    ${path}redis-cli shutdown
fi