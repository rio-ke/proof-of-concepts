## custom-host-domain-setup-implementation-in-kubernetes.md

you must need to verify the  coredns-custom configmap configurations. use below commands to validate

```bash
kubectl get configmaps --namespace=kube-system coredns-custom -o yaml
```

```bash
kubectl edit configmap coredns -n kube-system
```


```yaml
apiVersion: v1
data:
  Corefile: |-
    .:5353 {
        bind xxxx
        cache 30
        errors
        health xxxx:8080
        kubernetes cluster.local in-addr.arpa ip6.arpa {
          pods insecure
          fallthrough in-addr.arpa ip6.arpa
        }
        hosts {
          192.168.1.1 fourtimes.ml
          fallthrough
        }
        loadbalance round_robin
        prometheus xxxx:9153
        forward . /etc/resolv.conf
        reload
    }
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

Reference[https://support.huaweicloud.com/intl/en-us/usermanual-cce/cce_01_0361.html]
