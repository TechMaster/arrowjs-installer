#!/bin/bash
file_name=$1
server_name=$2
listen_port=$3
root_path=$4
upstream=$5

if [ -f "/etc/nginx/conf.d/${file_name}" ]; then
    echo -n "exists"
    return
fi

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

chcon -R -t httpd_sys_rw_content_t ${root_path}

./shell_scripts/nginx/toggle_active.sh $os_id $os_version restart



