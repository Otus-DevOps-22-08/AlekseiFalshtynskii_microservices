# AlekseiFalshtynskii_microservices
AlekseiFalshtynskii microservices repository

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
