USER_NAME ?= alekseif6

.PHONY: all
all: build_all push_all start

.PHONY: build_all
build_all: build_post build_comment build_ui build-prometheus

build_post:
	docker build -f ../src/post-py/Dockerfile -t $(USER_NAME)/post ../src/post-py

build_comment:
	docker build -f ../src/comment/Dockerfile -t $(USER_NAME)/comment ../src/comment

build_ui:
	docker build -f ../src/ui/Dockerfile -t $(USER_NAME)/ui ../src/ui

build-prometheus:
	docker build -f ../monitoring/prometheus/Dockerfile -t $(USER_NAME)/prometheus ../monitoring/prometheus

.PHONY: push_all
push_all: push_post push_comment push_ui push_prometheus

push_post:
	docker push $(USER_NAME)/post

push_comment:
	docker push $(USER_NAME)/comment

push_ui:
	docker push $(USER_NAME)/ui

push_prometheus:
	docker push $(USER_NAME)/prometheus

start:
	docker-compose down
	docker-compose up -d
