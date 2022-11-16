**ingress-rewrite-rule.md**

 ```js
 app.get("/healthz", (req, res) => {
    res.send({"statusCode: 200, "Message": "runnning"})
 }
 ```
_Ingress_

```yml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "400"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "400"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "400"
    proxy-connect-timeout: "400"
    proxy-read-timeout: "400"
    proxy-send-timeout: "400"
  name: ingress-mlops
spec:
  ingressClassName: nginx
  rules:
    - http:
        paths:
          - path: /api/ml/ml-incidents-modops-model/(.*)
            pathType: Prefix
            backend:
              service:
                name: ml-incidents-modops-model
                port:
                  number: 80
          - path: /api/ml/ml-changes-modops-model/(.*)
            pathType: Prefix
            backend:
              service:
                name: ml-changes-modops-model
                port:
                  number: 80
```

_access url_

```bash
curl http://ingressControllerIP/api/ml/ml-changes-modops-model/healthz
```
