#!/bin/bash
# Check OS version
if [ -f "/etc/os-release" ]; then
    osname=`cat /etc/os-release | grep ID= | head -1 | sed 's/\"//g'`
    osname=${osname:3}                                 
    osversion=`cat /etc/os-release | grep VERSION_ID= | head -1 |  sed 's/\"//g'`
    osversion=${osversion:11}
    osname=$osname$osversion
    echo -n "$osname"
    exit
fi

if [ -f "/etc/system-release" ]; then
    sysrelease=`cat /etc/system-release`

    # Centos
    if [[ $sysrelease == CentOS* ]]; then        
        osversion=`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`
        osname="centos$osversion"
	    echo -n "$osname"
        exit
    fi

    ## Fedora
    if [[ $sysrelease == Fedora* ]]; then
    	osversion=`rpm -q --qf "%{VERSION}" fedora-release`
    	osname="fedora$osversion"
    	echo -n "$osname"
	    exit
    fi
else
    echo -n ""
    exit
fi
