#!/bin/bash
IP=`ifconfig | grep inet | awk '{ print $2; }' | awk -F":"  '{print $2}' | head -1`
echo "IP address: $IP"

osname=`cat /etc/system-release`
echo "Operating system: $osname"
