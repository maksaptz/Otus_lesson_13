#  Docker

Описание домашнего задания:
- изучить основные понятия контейнеризации;
- написать Dockerfile;
- запустить контейнер;
- запустить docker-compose.

## Цель домашнего задания:

Основное
1. Написать Dockerfile на базе apache/nginx который будет содержать две статичные web-страницы
на разных портах. Например, 80 и 3000;
2. Пробросить эти порты на хост машину. Обе страницы должны быть доступны по адресам
localhost:80 и localhost:3000;
3. Добавить 2 вольюма. Один для логов приложения, другой для web-страниц.

Доп.*
1. Написать Docker-compose для приложения Redmine, с использованием опции build;
2. Добавить в базовый образ redmine любую кастомную тему оформления;
3. Убедиться что после сборки новая тема доступна в настройках.

### Ход выполнения домашнего задани

Комментарии выполняемых комманд описаны в скриптах.

#### Проверка домашнего задания

Основное
1) Запускаем task_1/Vagrantfile
2) curl 127.0.0.1
3) curl 127.0.0.1:3000
4) Видим что обе страницы доступны

Доп. задание
1) Запускаем task_2/Vagrantfile
2) В моем случае проброс портов идет до машины на которой стоит vagrant
3) В браузере открываем 127.0.0.1:8080
4) Логинимся admin admin, заходим в настройки применяем update настроек во всплывающем окне, на вкладке display меняем тему(см. скриншот в папке task_2)
