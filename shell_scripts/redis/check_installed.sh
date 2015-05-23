#!/bin/bash
redis_version=`redis-server -v | awk '{print $3}' | awk -F"=" '{print $2}'`
