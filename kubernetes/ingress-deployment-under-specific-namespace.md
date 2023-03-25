


```bash
RELEASE_NAME=client1-ingress

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install $RELEASE_NAME ingress-nginx/ingress-nginx  \
  --namespace $RELEASE_NAME --create-namespace \
  --set controller.ingressClassByName=true \
  --set controller.ingressClassResource.name=$RELEASE_NAME \
  --set controller.ingressClassResource.controllerValue="k8s.io/$RELEASE_NAME" \
  --set controller.ingressClassResource.enabled=true \
  --set controller.replicaCount=2

```
