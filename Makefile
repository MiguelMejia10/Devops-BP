REGISTRY ?= docker.io/$(DOCKER_USER)
IMAGE ?= $(REGISTRY)/demo-devops-java
TAG ?= local

build:
	docker build -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)

k8s-apply:
	kubectl apply -f k8s/namespace.yaml
	kubectl -n demo apply -f k8s/configmap.yaml -f k8s/secret.yaml -f k8s/deployment.yaml -f k8s/service.yaml -f k8s/ingress.yaml

k8s-rollback:
	kubectl -n demo rollout undo deploy/demo-app

test:
	mvn -q clean verify
