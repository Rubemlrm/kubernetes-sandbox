echo "Adding helm needed repositories"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

echo "Installing needed charts"
helm install prometheus prometheus-community/prometheus
helm install prometheus-exporter prometheus-community/prometheus-node-exporter
helm install grafana grafana/grafana

echo "Setup services"
kubectl create -f grafana/
kubectl create -f hello-deployment/
kubectl create -f prometheus/
kubectl create -f syncthing
kubectl create -f ingress-controller.yaml
