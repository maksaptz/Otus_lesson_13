#!/bin/bash

### обновляем и устанавливаем необходимые пакеты
apt update
apt install docker.io docker-compose git -y

### создаем директорию с темамами и скачиваем их с гита
mkdir /redmine_themes

cd /redmine_themes
sudo git clone -b redmine4.1  https://github.com/farend/redmine_theme_farend_bleuclair.git public/themes/bleuclair

cd ~

### конфиг докера
echo "FROM redmine:4.1
RUN apt update" > Dockerfile

### yml file который поднимает redmine и моунтит директорию с новыми темами
echo "version: '3.3'
services:
   postgres:
        image: postgres:10
        environment:
          POSTGRES_PASSWORD: "strong_pass"
          POSTGRES_DB: "redmine"
          PGDATA: "/var/lib/postgresql/data"
        restart: always
   redmine:
     build:
       context: .
     image: redmine:custom
     ports:
       - 8080:3000
     volumes:
       - /redmine_themes/public/themes:/usr/src/redmine/public/themes
     environment:
       REDMINE_DB_POSTGRES: "postgres"
       REDMINE_DB_USERNAME: "postgres"
       REDMINE_DB_PASSWORD: "strong_pass"
       REDMINE_DB_DATABASE: "redmine"
       REDMINE_SECRET_KEY_BASE: "..."
     restart: always" > docker-compose.yml

### запускаем docker     
docker-compose up -d
