#!/bin/bash
# Add Nginx repo
printf '[nginx]\nname=nginx repo\nbaseurl=http://nginx.org/packages/centos/$releasever/$basearch/\ngpgcheck=0\nenabled=1' > /etc/yum.repos.d/nginx.repo

# Install Nginx with yum
yum install nginx -y
