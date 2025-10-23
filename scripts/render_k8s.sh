#!/usr/bin/env bash
set -euo pipefail
: "${IMAGE_TAG:=latest}"
: "${REGISTRY:=docker.io/library}"
sed -i.bak "s#<TU_REGISTRO>/demo-devops-java:${IMAGE_TAG}#${REGISTRY}/demo-devops-java:${IMAGE_TAG}#g" k8s/deployment.yaml
