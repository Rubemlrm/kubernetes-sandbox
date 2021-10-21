echo "Adding helm needed repositories"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

echo "Installing needed charts"
helm install prometheus prometheus-community/prometheus
helm install grafana grafana/grafana
