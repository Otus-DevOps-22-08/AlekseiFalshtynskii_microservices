# AlekseiFalshtynskii_microservices
AlekseiFalshtynskii microservices repository

### HW14
Запущен тестовый контейнер с использованием различных сетевых драйверов (none, host, bridge)\
Создана bridge-сеть и в ней запущены микросервисы приложения\
Созданы 2 изолированные сети и в них запущены микросервисы - ui без доступа к бд\
Приложение запущено по декларативному описанию docker-compose.yml\
Изменен docker-compose.yml с указанием каждому сервису своей подсети (front_net, back_net)\
Параметризованы порты публикации и внутренний ui, версии сервисов, подсети\
Значения параметров вынесены в .env\
Проверен запуск параметризованного docker-compose.yml
```
Базовое название проекта получается добавлением префикса - названием каталога, из которого запускаются контейнеры\
Переопределяется:
- в docker-compose.yml свойством name: reddit
- в .env файле переменной COMPOSE_PROJECT_NAME=reddit
- при старте параметром -p reddit
```
★ Написан docker-compose.override.yml, который позволяет запускать образы приложения без пересборки и запускать puma в comment и ui в дебаг режиме с двумя воркерами

### HW13
Написаны 3 docker файла для развертывания 3 микросервисов на docker хосте\
В качестве оптимизации инструкций ADD заменена на COPY, сокращено число слоев, убрана установка env и создание рабочего каталога, оставлено сразу WORKDIR\
Создана bridge-сеть для контейнеров\
Собраны и запущены в этой сети 3 сервиса + mongodb\
Для этого пришлось подбирать версию pymongo=4.0.2 и заменить команду insert на insert_one в post_app.py
```
pymongo.errors.OperationFailure: Unsupported OP_QUERY command: find. The client driver may require an upgrade
pymongo.errors.OperationFailure: Unsupported OP_QUERY command: insert. The client driver may require an upgrade
```
Контейнеры остановлены и запущены с другими альясами (с постфиксом 2). Проверены, что работают также
```
% docker run -d --network=reddit --network-alias=post_db2 --network-alias=comment_db2 mongo:latest
% docker run -d --network=reddit --network-alias=post2 --env POST_DATABASE_HOST=post_db2 alekseif6/post:1.0
% docker run -d --network=reddit --network-alias=comment2 --env COMMENT_DATABASE_HOST=comment_db2 alekseif6/comment:1.0
% docker run -d --network=reddit -p 9292:9292 --env POST_SERVICE_HOST=post2 --env COMMENT_SERVICE_HOST=comment2 alekseif6/ui:1.0
```
Создан volume и примонтирован к контейнеру mongo, чтобы сообщения не пропадали при рестарте\
★ В Dockerfile.1 сконфигурированы образы на основе чистого alpine и установкой минимально необходимо набора пакетов и удаления в конце инсталляции для минимизации объемов образов
```
alekseif6/comment   1.0            0ce1c01a78e6   8 minutes ago    40.6MB
alekseif6/post      1.0            41580e4ad8b2   11 minutes ago   80MB
alekseif6/ui        1.0            7ccadec7c726   22 minutes ago   43.7MB
```

### HW12
Установлен Docker и docker-machine отдельно - удален в последних версиях\
Запущены тестовые образы, отработаны теоретические команды\
Создан docker-хост в yandex cloud\
Создан образ с приложением reddit и запущен контейнер из него\
Образ запушен в docker hub и проверен запуск со скачиванием\
★ Сравнены выводы команд inspect image / container, результаты в docker-1.log\
★ Сконфигурировано автоматизированное поднятие инстансов с установленным docker и запущенным контейнером из выше сконфигурированного образа\
- Написаны конфигурации terraform с параметризированным количеством инстансов (проверено на 2)
- Написаны 3 плейбука ansible для установки docker (для packer), для запуска контейнера из образа и полный с обоими предыдущими для ручного запуска
- Написан packer шаблон для создания образа инстанса с установленным docker на борту\
Для проверки конфигураций выполнены команды:
```
cd docker-monolith/infra/terraform && terraform init && terraform apply --auto-approve
```
```
cd ../ansible && ansible-playbook playbooks/deploy_docker_image.yml
```
```
cd .. && packer build --var-file=packer/variables.json packer/docker_host.json
```
