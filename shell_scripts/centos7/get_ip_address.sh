#!/bin/bash
IP=`ip addr|grep inet | head -3 | tail -1 | sed 's/inet\(.* \)\(.* \)\(.* \)\(.* \)\(.* \).*/\1/' | sed 's/ //g' | sed 's/...$//'`
echo -n "$IP"
