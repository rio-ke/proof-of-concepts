## Readme.md

_switch the namespace_

```bash
kubectl config set-context --current --namespace=argocd
```
_change the exist service type_

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
