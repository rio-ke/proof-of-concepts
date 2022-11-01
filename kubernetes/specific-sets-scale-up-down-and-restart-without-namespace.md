

```sh
#!/usr/bin/env bash

actionState=$1
setType=$2
nameOfSets=$3

if [[ $actionState == "restart" ]]; then
    getDeplomentsets=$(kubectl get "${setType}" 2>/dev/null | awk '{print $1}' | egrep -v 'NAME')
    if [[ $getDeplomentsets != "" ]]; then
        for deploymentset in $getDeplomentsets; do
            kubectl rollout restart "${setType}" "${nameOfSets}"
            totalDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $2}')
            while true; do
                runningDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $1}')
                if [ $totalDeploymentsetReplicas == $runningDeploymentsetReplicas ]; then
                    echo "${setType} - ${nameOfSets} has been restarted"
                    sleep 2
                    break
                else
                    echo "${setType} - ${nameOfSets} is restarting"
                    sleep 2
                fi
            done
        done
    else
        echo "No resources found"
    fi
elif [[ $actionState == "up" ]]; then
    getDeplomentsets=$(kubectl get "${setType}" 2>/dev/null | awk '{print $1}' | egrep -v 'NAME')
    if [[ $getDeplomentsets != "" ]]; then
        for deploymentset in $getDeplomentsets; do
            kubectl scale --replicas=1 "${setType}" "${nameOfSets}"
            totalDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $2}')
            while true; do
                runningDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $1}')
                if [ $totalDeploymentsetReplicas == $runningDeploymentsetReplicas ]; then
                    echo "${setType} - ${nameOfSets} has been restarted "
                    sleep 2
                    break
                else
                    echo "${setType} - ${nameOfSets} is restarting"
                    sleep 2
                fi
            done
        done
    else
        echo "No resources found"
    fi
elif [[ $actionState == "down" ]]; then
    getDeplomentsets=$(kubectl get "${setType}" 2>/dev/null | awk '{print $1}' | egrep -v 'NAME')
    if [[ $getDeplomentsets != "" ]]; then
        for deploymentset in $getDeplomentsets; do
            kubectl scale --replicas=0 "${setType}" "${nameOfSets}"
            totalDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $2}')
            while true; do
                runningDeploymentsetReplicas=$(kubectl get "${setType}" "${nameOfSets}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $1}')
                if [ $totalDeploymentsetReplicas == $runningDeploymentsetReplicas ]; then
                    echo "${setType} - ${nameOfSets} has been restarted "
                    sleep 2
                    break
                else
                    echo "${setType} - ${nameOfSets} is restarting"
                    sleep 2
                fi
            done
        done
    else
        echo "No resources found"
    fi
else
    echo "None of the condition met"
fi

```

deploymentset execution method for 

```bash
# filename should be main.sh
# bash main.sh up deploy frontend
# bash main.sh up deploy frontend
# bash main.sh down deploy frontend
```


statefulset execution method for 

```bash
# filename should be main.sh
# bash main.sh up sts frontend
# bash main.sh up sts frontend
# bash main.sh down sts frontend
```
