
_certificate creation_

```bash
kubectl create secret tls fourtimes-ml-certs --key server.key --cert server.crt
```

_ingress deployment yaml file_

```yml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: jobs
  annotations:
    ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "1800"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "1800"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - dodo.fourtimes.ml
    secretName: fourtimes-ml-certs
  rules:
  - host: dodo.fourtimes.ml
    http:
      paths:
      - path: /
        pathType: Prefix # ImplementationSpecific
        backend:
          service:
            name: jobs
            port:
              number:  9002

```

_optional secret creation as yaml file_

```yml
apiVersion: v1
kind: Secret
metadata:
  name: fourtimes-ml-certs
type: kubernetes.io/tls
data:
  server.crt: |
       <crt contents here>
  server.key: |
       <private key contents here>
```
