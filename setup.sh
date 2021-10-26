echo "Adding helm needed repositories"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

echo "Installing needed charts"
kubectl create namespace syncthing
kubectl create namespace hello-deployment
kubectl create namespace monitoring
helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring

echo "Setup services"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
sleep 40
kubectl create -f hello-deployment
kubectl create -f syncthing
kubectl create -f monitoring
