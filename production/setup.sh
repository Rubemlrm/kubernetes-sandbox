#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

kubectl config use-context kind-production-cluster

echo "Adding helm needed repositories"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add jetstack https://charts.jetstack.io
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

echo "Taint nodes"
kubectl taint nodes production-cluster-worker target=backend:NoSchedule
kubectl taint nodes production-cluster-worker2 target=backend:NoSchedule
kubectl taint nodes production-cluster-worker3 target=frontend:NoSchedule
kubectl taint nodes production-cluster-worker4 target=backend:NoSchedule

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
