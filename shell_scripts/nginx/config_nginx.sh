#!/bin/bash
os_id=$1
os_version=$2
file_name=$3
server_name=$4
listen_port=$5
root_path=$6
upstream=$7

#if [ -f "/etc/nginx/conf.d/${file_name}" ]; then
#    echo -n "exists"
#    return
#fi

check_active=`./shell_scripts/nginx/check_active.sh $os_id $os_version`
if [ -z "$check_active" ]; then
    echo "Start Nginx service"
    ./shell_scripts/nginx/toggle_active.sh $os_id $os_version start
fi

printf "# Default config by arrowjs.io
upstream ${upstream} {
    server 127.0.0.1:${listen_port};
}

server {
	listen  80;
    	server_name ${server_name};

	location ~* \.(png|ico|gif|jpg|jpeg|css|js|eot|svg|ttf|woff|map)$ {
        	root ${root_path};
        	expires 7d;
   	}

	location / {
        	proxy_set_header X-Real-IP \$remote_addr;
        	proxy_set_header Upgrade \$http_upgrade;
        	proxy_set_header Connection "upgrade";
        	proxy_http_version 1.1;
        	proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        	proxy_set_header Host \$host;
        	proxy_pass http://${upstream};
    	}
}
" > /etc/nginx/conf.d/${file_name}

# Add port to SELinux in CentOS7
if [[ "$os_id" == "centos" || "$os_id" == "fedora" ]]; then
    yum install policycoreutils-python -y
    semanage port --add --type http_port_t --proto tcp $listen_port
    chcon -R -t httpd_sys_rw_content_t $root_path
fi

./shell_scripts/nginx/toggle_active.sh $os_id $os_version restart