# AlekseiFalshtynskii_microservices
AlekseiFalshtynskii microservices repository

### HW20
Развернут kubernetes кластер minikube локально\
Описаны конфигурации деплоев микросервисов и бд\
Описаны конфигурации сервисов для доступа контейнеров к бд\
Создано окружение dev и развернуты контейнеры в нем\
Включен и настроен dashboard, с помощью применения конфигураций из документации\
Аналогично создан и настроен кластер в yandex cloud\

★ Автоматизировано развертывание кластера в yc с помощью terraform\
Микросервисы задеплоены в облачный кластер\
Включен dashboard в облачном кластере\
Конфигурации для dashboard приложены в одноименном каталоге

### HW19
Создана новая ВМ для развертывания GitLab\
Установлен docker, создан compose-файл, запущен контейнер GitLab\
Пароль для root получен командой внутри ВМ
```
sudo docker exec -it gitlab_web_1 grep 'Password:' /etc/gitlab/initial_root_password
```
Отключена регистрация в GitLab\
Создана группа homework, в группе создан проект example\
Добавлен remote сервер git в локальную конфигурацию\
В Settings - Access Tokens создан токен для авторизации в remote на локале\
Описан CI/CD pipeline в файле .gitlab-ci.yml\
Добавлен и зарегистрирован GitLab Runner для запуска pipeline\
В проект добавлен код reddit приложения. Добавлены тесты в pipeline, проверены их выполнения\
Добавлены окружения dev, staging и production\
Добавлены динамические окружения, проверены их создания для новых веток

★ Автоматизировано развертывание и настройка GitLab CI
Создание ВМ для GitLab описано в terraform\
Установка docker и установка и настройка GitLab описаны в ansible playbooks docker.yml и gitlab.yml\
★ Автоматизировано развертывание GitLab Runner\
Конфигурация описана в ansible playbook gitlab-runner.yml
★ Slack более недоступен, поэтому добавлены оповещения в Telegram\
Создан тестовый чат, туда добавлен Gitlab_bot, его ссылка на Web Hook добавлена в Settings - Webhooks в GitLab\
![Telegram Notification](https://downloader.disk.yandex.ru/preview/609157a5fb526a128def8db932fa7f7edd22d4699bc6123aa8217558a2f34b12/64335c0b/p7rNy0Hui4UnxOyB2He5Iopah7AN2z_LXrk1jlB8K4OSlqQgSs7chKFONp8uMK1g8gT4zC1KQOKF1bn3vozcWQ%3D%3D?uid=0&filename=Screen%20Shot%202023-04-09%20at%2023.15.41.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=0&tknv=v2&size=2048x2048)

### HW18
Установлен и настроен Kubernetes, разобраны на практике основные компоненты Kubernetes\
Созданы deployment файлы микросервисов в каталоге kubernetes/reddit\
★ Описаны конфигурации установки кластера k8s с помощью terraform и ansible\
Манифесты terraform разбиты на 2 модуля - создание master ноды и worker нод\
В ansible конфигурации применен динамический inventory плагином yc_compute из прошлых дз\
Плейбуки ansible разбиты на установку docker, установку k8s, создание и настройку master ноды и настройку worker нод\
После применения конфигураций получен результат созданных нод\
```
% ssh -i ~/.ssh/appuser ubuntu@130.193.37.26 kubectl get nodes
The authenticity of host '130.193.3A) to the list of known hosts.
NAME                   STATUS   ROLES                  AGE   VERSION
fhm0dso7hcttl0o4s01r   Ready    control-plane,master   78s   v1.22.16
fhm7a2bn3eut77lgma4g   Ready    <none>                 55s   v1.22.16
```
Манифесты деплоя микросервисов скопированы на master ноду и применены
```
scp -i ~/.ssh/appuser -r ./kubernetes/reddit user@130.193.37.26:~/reddit
```
Результат команды kubectl get pods
```
ubuntu@fhm0dso7hcttl0o4s01r:~/reddit$ kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
comment-deployment-66dd866999-zg4bb   1/1     Running   0          16s
mongo-deployment-695df8c78c-pp2c5     1/1     Running   0          6s
post-deployment-6499899c9f-mm9ng      1/1     Running   0          22s
ui-deployment-5b468486c5-rtm5x        1/1     Running   0          11s
```
Для прохождения тестов добавлен каталог /kubernetes/the_hard_way с пустыми файлами
```
kube-controller-manager.kubeconfig
kube-scheduler.kubeconfig
worker-0.kubeconfig
```

### HW17
Обновлен код микросервисов для логирования\
Создан compose-файл для системы логирования\
Сконфигурирован образ fluentd\
Настроен сбор и отправка логов post и ui в fluentd\
Просмотрены логи в kibana, создан индекс и применены поиски\
Применен regexp парсинг json-логов в структурированные логи\
Применены grok-паттерны для преобразования в структурированные логи\
★ Дополнительно разобран формат сообщений
```
message     service=ui | event=request | path=/ | request_id=2e4758ed-6b7e-4ed9-8185-e71dbbbeb16a | remote_addr=79.137.205.34 | method=get | response_status=200
```
Применен grok-паттерн
```
grok_pattern service=%{WORD:service} \| event=%{WORD:event} \| path=%{URIPATH:path} \| request_id=%{UUID:request_id} \| remote_addr=%{IP:remote_addr} \| method= %{WORD:method} \| response_status=%{NUMBER:response_status}
```
Добавлен сервис Zipkin для распределенного трейсинга\
Подключен к кастомным сетям font_net и back_net\
Просмотрены трейсы сервисов при отправке сообщений\
★ Выполнен траблшутинг ui сломанного кода
Проблема: страницы с постами загружаются дольше 3 секунд\
В трассировке определен длительный запрос /post/{id}, в коде соответствует методу find_post(id), на 167 строке "тормозящий" вызов - time.sleep(3)

### HW16
Запущен дефолтный prometheus\
Сконфигурирован prometheus.yml для мониторинга сервисов\
Изучен web ui prometheus\
Собраны метрики хоста с использованием node экспортера\
★ Добавлен мониторинг MongoDB с использованием экспортера percona/mongodb_exporter\
Для этого создан пользователь в бд с нужными доступами\
```
docker exec -it {container_id} sh
mongo
use admin
db.createUser({user: "test", pwd: "testing", roles: [{role: "clusterMonitor", db: "admin"}, {role: "read", db: "local"}]})
```
★ Добавлен мониторинг сервисов comment, post, ui с помощью prom/blackbox-exporter
★ Написан Makefile, умеющий собирать, пушить в хаб и стартовать образы

### HW15
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

### HW14
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

### HW13
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
