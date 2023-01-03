_values_

```yml
# values.yml
alertmanager:
  enabled: false
kubeControllerManager:
  enabled: false
kubeEtcd:
  enabled: false
kubeProxy:
  enabled: false
kubeScheduler:
  enabled: false
prometheusOperator:
  tls:
    enabled: false
  admissionWebhooks:
    enabled: false
```

_command_

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
helm repo add stable https://charts.helm.sh/stable 
helm repo update
kubectl create ns monitoring
helm install prometheus-operator prometheus-community/kube-prometheus-stack -f values.yml  -n monitoring
```
