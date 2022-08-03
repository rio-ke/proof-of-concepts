## custom-host-domain-setup-implementation.md

you must need to verify the  coredns-custom configmap configurations. use below commands to validate

```bash
kubectl get configmaps --namespace=kube-system coredns-custom -o yaml
```

I want to resolve these domains from the AKS cluster in this real-time use case, hence I intend to change the settings of coredns-custom configmap. 

```yaml
# coredns-custom.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom
  namespace: kube-system
data:
  log.override: |
        log
  test.override: |
        hosts { 
            10.42.60.7 wn0-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net
            10.42.60.5 wn1-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net
            10.42.60.6 wn2-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net
            fallthrough
        }
```
execute the yml file to populate the custom domain to all pods.

```bash
kubectl apply -f coredns-custom.yml 
```

Recreate the core-dns pod once the pod has been deployed in order to reflect any changes made at the cluster level.

```bash
kubectl delete pod --namespace kube-system -l k8s-app=kube-dns
```

validate the log based on your configuration

```bash
kubectl logs --namespace kube-system --selector k8s-app=kube-dns
```

Results
  once everything validate you can use those domain name instead of ipaddress to configure the application level configurations.
