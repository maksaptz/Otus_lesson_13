#!/bin/bash

### обновим менеджер пакетов и установим пакеты необходимые для работы
apt update
apt install docker.io -y

### заранее создадим папку для тома где будет храниться конфиг web страниц
mkdir -p /var/lib/docker/volumes/web/_data/

### создаем конфиг для запуска 2 страниц на разных портах
echo "server {
    listen       80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;
	
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}

server {
    listen       3000;
    server_name  localhost1;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}" > /var/lib/docker/volumes/web/_data/default.conf

### добавим сам Dockerfile
echo "FROM nginx
ADD ./nginx.conf /etc/nginx/" > ./Dockerfile

### в конфиге nginx укажем путь до логов и конфигов страниц которые будут находиться на примонтированных томах
echo "user  nginx;
worker_processes  auto;

error_log  /nginx_log/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /nginx_log/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /web/*.conf;
}" > ./nginx.conf

### соберем контейнер
docker build -t mynginx .

### запустим контейнер с пробросом портов и маунтом томов на хостовой машине
docker run -dt -p=80:80 -p=3000:3000 -v=web:/web -v=nginx_log:/nginx_log --name double_html mynginx
#docker exec -it double_html bash
#curl 127.0.0.1
#curl 127.0.0.1:3000
