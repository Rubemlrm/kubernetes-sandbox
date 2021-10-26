echo "Adding helm needed repositories"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

echo "Installing needed charts"
#helm install prometheus prometheus-community/prometheus --create-namespace
#helm install prometheus-exporter prometheus-community/prometheus-node-exporter --create-namespace
helm install monitoring prometheus-community/kube-prometheus-stack --create-namespace

echo "Setup services"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl create -f grafana/
kubectl create -f hello-deployment/
kubectl create -f prometheus/
kubectl create -f syncthing
kubectl create -f ingress-controller.yaml
