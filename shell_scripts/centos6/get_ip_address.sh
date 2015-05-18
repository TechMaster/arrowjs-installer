#!/bin/bash
IP=`ifconfig | grep inet | awk '{ print $2; }' | awk -F":"  '{print $2}' | head -1`
echo -n "$IP"
