#!/bin/bash
# Open listen addresses with parameter 1
sed -i "s/\(^.*listen_addresses\)\([\t ]*=[\t ]*\)\([^\t]*\)\([\t ]*\)\(.*\)/listen_addresses\2'${1}'\4\5/" /var/lib/pgsql/9.4/data/postgresql.conf