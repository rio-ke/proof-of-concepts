[apache-superset](https://superset.apache.org/docs/installation/running-on-kubernetes/)

```bash
kubectl create ns superset
helm repo add superset https://apache.github.io/superset
helm install -n superset superset superset/superset
kubectl port-forward service/superset 8088:8088 --namespace superset
```
