#!/bin/bash
if [ -f "/etc/os-release" ]; then
    # Ubuntu, Lubuntu, Debian, CentOS7
    os_name=`cat /etc/os-release | sed -n 's/^ID=// p' | sed 's/\"//g'`
    os_version=`cat /etc/os-release | sed -n -r 's/^VERSION_ID="(.*)"$/\1/ p' | sed 's/\.//g'`

    # Fedora
    if [[ $os_name == "fedora" ]]; then
        os_version=`rpm -q --qf "%{VERSION}" fedora-release`
    fi

    echo -n "${os_name}-${os_version}"
    exit
fi

if [ -f "/etc/system-release" ]; then
    system_release=`cat /etc/system-release`

    # CentOS6
    if [[ $system_release == CentOS* ]]; then
        os_name="centos"
        os_version=`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`
	    echo -n "${os_name}-${os_version}"
        exit
    fi
else
    echo -n ""
    exit
fi
