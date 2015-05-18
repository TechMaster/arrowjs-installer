#!/bin/bash
IP=`ip addr|grep inet | head -3 | tail -1 | sed 's/inet\(.* \)\(.* \)\(.* \)\(.* \)\(.* \).*/\1/' | sed 's/ //g' | sed 's/...$//'`
echo "IP address: $IP"

osname=`cat /etc/os-release|grep PRETTY_NAME=| head -1 | sed 's/\"//g'`
osname=${osname:12}
echo "Operating system: $osname"
