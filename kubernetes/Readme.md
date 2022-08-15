## Readme.md

```bash
# switch the namespace
kubectl config set-context --current --namespace=argocd
# change the exist service 
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
