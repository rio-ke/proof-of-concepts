_eviction-pod-deletion.md_

```bash
#!/usr/bin/env bash
for namespace in $(kubectl get ns | awk '{print $1}' | grep -v NAME); do
  echo This is the ${namespace} namespace
  kubectl get pod -n ${namespace} | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n ${namespace}
done

```
