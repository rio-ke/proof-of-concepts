

```sh
#!/usr/bin/env bash

actionState=$1
setType=$2
nameOfSets=$3
nameSpace=$4

if [[ $actionState == "restart" ]]; then
    getDeplomentsets=$(kubectl get "${setType}" -n "${nameSpace}" 2>/dev/null | awk '{print $1}' | egrep -v 'NAME')
    if [[ $getDeplomentsets != "" ]]; then
        for deploymentset in $getDeplomentsets; do
            kubectl rollout restart "${setType}" "${nameOfSets}" -n "${nameSpace}"
            totalDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" -n "${nameSpace}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $2}')
            while true; do
                runningDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" -n "${nameSpace}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $1}')
                if [ $totalDeploymentsetReplicas == $runningDeploymentsetReplicas ]; then
                    echo "${setType} - ${nameOfSets} has been restarted in ${nameSpace} "
                    sleep 2
                    break
                else
                    echo "${setType} - ${nameOfSets} is restarting in ${nameSpace} "
                    sleep 2
                fi
            done
        done
    else
        echo "No resources found in ${nameSpace}."
    fi
elif [[ $actionState == "up" ]]; then
    getDeplomentsets=$(kubectl get "${setType}" -n "${nameSpace}" 2>/dev/null | awk '{print $1}' | egrep -v 'NAME')
    if [[ $getDeplomentsets != "" ]]; then
        for deploymentset in $getDeplomentsets; do
            kubectl scale --replicas=1 "${setType}" "${nameOfSets}" -n "${nameSpace}"
            totalDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" -n "${nameSpace}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $2}')
            while true; do
                runningDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" -n "${nameSpace}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $1}')
                if [ $totalDeploymentsetReplicas == $runningDeploymentsetReplicas ]; then
                    echo "${setType} - ${nameOfSets} has been restarted in ${nameSpace} "
                    sleep 2
                    break
                else
                    echo "${setType} - ${nameOfSets} is restarting in ${nameSpace} "
                    sleep 2
                fi
            done
        done
    else
        echo "No resources found in ${nameSpace}."
    fi
elif [[ $actionState == "down" ]]; then
    getDeplomentsets=$(kubectl get "${setType}" -n "${nameSpace}" 2>/dev/null | awk '{print $1}' | egrep -v 'NAME')
    if [[ $getDeplomentsets != "" ]]; then
        for deploymentset in $getDeplomentsets; do
            kubectl scale --replicas=0 "${setType}" "${nameOfSets}" -n "${nameSpace}"
            totalDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" -n "${nameSpace}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $2}')
            while true; do
                runningDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" -n "${nameSpace}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $1}')
                if [ $totalDeploymentsetReplicas == $runningDeploymentsetReplicas ]; then
                    echo "${setType} - ${nameOfSets} has been restarted in ${nameSpace} "
                    sleep 2
                    break
                else
                    echo "${setType} - ${nameOfSets} is restarting in ${nameSpace} "
                    sleep 2
                fi
            done
        done
    else
        echo "No resources found in ${nameSpace}."
    fi
else
    echo "None of the condition met"
fi

```

execution

```bash
# filename should be main.sh
# bash main.sh up deploy frontend default
# bash main.sh up deploy frontend default
# bash main.sh down deploy frontend default
```
