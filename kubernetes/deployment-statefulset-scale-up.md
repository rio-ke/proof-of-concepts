
```bash
#!/usr/bin/env bash

getNameSpaceDetails=$(kubectl get ns | awk '{print $1}' | egrep -v 'NAME|kube-system|kube-public|kube-node-lease')

for namespace in $getNameSpaceDetails; do
    echo "Restart process started on ${namespace} namespace"
    getDeplomentsets=$(kubectl get deploy,sts -n "${namespace}" 2>/dev/null | awk '{print $1}' | egrep -v 'NAME')
    if [[ $getDeplomentsets != "" ]]; then
        for deploymentset in $getDeplomentsets; do
            kubectl scale --replicas=1 "${deploymentset}" -n "${namespace}"
            totalDeploymentsetReplicas=$(kubectl get "${deploymentset}" -n "${namespace}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $2}')
            while true; do
                runningDeploymentsetReplicas=$(kubectl get "${deploymentset}" -n "${namespace}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $1}')
                if [ $totalDeploymentsetReplicas == $runningDeploymentsetReplicas ]; then
                    echo "${deploymentset} has been restarted"
                    sleep 2
                    break
                else
                    echo "${deploymentset} is restarting"
                    sleep 2
                fi
            done
        done
    else
        echo "No resources found in ${namespace}."
    fi
    echo "Restart process has been completed in ${namespace} namespace"
done
```
