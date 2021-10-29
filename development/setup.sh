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
kubectl taint nodes development-cluster-worker2 target=backend:NoSchedule
kubectl taint nodes development-cluster-worker3 target=frontend:NoSchedule


kubectl label nodes development-cluster-worker2 target=backend
kubectl label nodes development-cluster-worker3 target=frontend

