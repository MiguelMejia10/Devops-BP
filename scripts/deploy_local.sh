#!/usr/bin/env bash
set -euo pipefail
kubectl apply -f k8s/namespace.yaml
kubectl -n demo apply -f k8s/configmap.yaml -f k8s/secret.yaml -f k8s/deployment.yaml -f k8s/service.yaml -f k8s/ingress.yaml
kubectl -n demo rollout status deploy/demo-app --timeout=120s
