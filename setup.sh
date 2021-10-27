#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "Adding helm needed repositories"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add jetstack https://charts.jetstack.io
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

echo "Taint nodes"
kubernetes taint nodes kind-worker target=backend:NoSchedule
kubernetes taint nodes kind-worker3 target=backend:NoSchedule
kubernetes taint nodes kind-worker6 target=backend:NoSchedule
kubernetes taint nodes kind-worker2 target=frontend:NoSchedule
kubernetes taint nodes kind-worker4 target=frontend:NoSchedule
kubernetes taint nodes kind-worker5 target=frontend:NoSchedule

echo "Create namespaces"
kubectl create namespace syncthing
kubectl create namespace hello-deployment
kubectl create namespace monitoring


echo "Installing needed charts"
helm install quickstart ingress-nginx/ingress-nginx
helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.4 \
  --set installCRDs=true

echo "Setup services"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
sleep 40

kubectl create -f hello-deployment
kubectl create -f syncthing
kubectl create -f monitoring
