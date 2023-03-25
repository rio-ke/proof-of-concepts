


```bash
RELEASE_NAME=gino-ingress

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


_ingress with specific ingress_


```yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: client1-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  ingressClassName: gino-ingress
  rules:
  - host: client1.domain.co
    http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: echello
            port:
              number: 80
```
