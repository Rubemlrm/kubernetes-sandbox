
echo "Setup services"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
sleep 40

echo "Setup services"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
sleep 40

fileToApply=(
              "namespace"
              "persistent-volume-claim"
              "persistent-volume"
              "configmap"
              "cronjob"
              "deployment"
              "service"
              "ingress-controller"
            )
for folder in $(find "$(pwd)/development" -type d -mindepth 1 -maxdepth 1); do
    for fileName in ${fileToApply[@]}; do
        file="$folder/$fileName.yaml"
        if test -f "$file"; then
            kubectl create -f $file
        fi
    done
done

echo "Installing needed charts"
kubectl create namespace monitoring
helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.4 \
  --set installCRDs=true

