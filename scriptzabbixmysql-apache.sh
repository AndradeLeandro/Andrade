#!/bin/bash

docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 rede-interna

mkdir -p /var/lib/mysql $$ docker run --name mysql-server -t \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="senha" \
      -e MYSQL_ROOT_PASSWORD="senha" \
      -v /var/lib/mysql/:/var/lib/mysql \
      --network=rede-interna \
      -d mysql --character-set-server=utf8 --collation-server=utf8_bin \
      --default-authentication-plugin=mysql_native_password

docker run --name zabbix-java-gateway -t \
      --restart unless-stopped \
      -d zabbix/zabbix-java-gateway \
      --network=rede-interna
      
      #:alpine-5.4-latest
      


docker run --name zabbix-server-mysql -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="senha" \
      -e MYSQL_ROOT_PASSWORD="senha" \
      -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
      --network=rede-interna \
      --link mysql-server:mysql \
      --link zabbix-java-gateway:zabbix-java-gateway \
      -p 10051:10051 \
      --restart unless-stopped \
      -d zabbix/zabbix-server-mysql
      
      #:alpine-5.4-latest


docker run --name zabbix-web-apache-mysql -t \
      -e ZBX_SERVER_HOST="zabbix-server-mysql" \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="senha" \
      -e MYSQL_ROOT_PASSWORD="senha" \
      --privileged \
      --network=rede-interna \
      --link mysql-server:mysql \
      --link zabbix-server-mysql:zabbix-server \
      -p 80:8080 \
      --restart unless-stopped \
      -d zabbix/zabbix-web-apache-mysql

      #-d zabbix/zabbix-web-nginx-mysql:alpine-5.4-latest

docker run --name zabbix-agent \
      --network=rede-interna \
      -e ZBX_HOSTNAME="Zabbix server" \
      -e ZBX_SERVER_HOST="zabbix-server-mysql" \
      --privileged \
      --link mysql-server:mysql \
      --link zabbix-server-mysql:zabbix-server \
      -d zabbix/zabbix-agent


