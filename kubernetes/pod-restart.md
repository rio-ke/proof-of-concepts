pod-restart.md

```bash
#!/bin/bash
echo "Choose your option"
echo "1.Only for one Namespace provided by User"
echo "2.Only for particular Environment provided by user"
echo "3.Will work for Every namespace"
read option
if [[ $option == 1 ]]; then
	echo "Enter the Namespace : "
	read op
	echo $op >Used_Namespaces.txt
	cp Used_Namespaces.txt choose.txt
elif [[ $option == 2 ]]; then
	echo "Enter the Environment : "
	read op
	kubectl config get-contexts -o name | egrep -i "$op" | grep -v "pprd | prd" >Environment.txt
	cp Environment.txt choose.txt
elif [[ $option == 3 ]]; then
	kubectl config get-contexts -o name | awk '{print $1}' >All_Namespaces.txt
	cp All_Namespaces.txt choose.txt
else
	echo "We are sorry you choose the Wrong option !!!"
fi

scaleDown() {
	kubectl scale --replicas=0 deploy "${deploymentset}"
	totalDeploymentsetReplicas=$(kubectl get deploy "${deploymentset}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $2}')
	while true; do
		runningDeploymentsetReplicas=$(kubectl get deploy "${deploymentset}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $1}')
		if [ $totalDeploymentsetReplicas == $runningDeploymentsetReplicas ]; then
			echo "${deploymentset} has been scale down"
			sleep 2
			break
		else
			echo "${deploymentset} is terminating."
			sleep 2
		fi
	done
}

scaleUp() {
	kubectl scale --replicas=1 deploy "${deploymentset}"
	totalDeploymentsetReplicas=$(kubectl get deploy "${deploymentset}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $2}')
	while true; do
		runningDeploymentsetReplicas=$(kubectl get deploy "${deploymentset}" | egrep -v 'NAME' | awk '{print $2}' | awk -F/ '{print $1}')
		if [ $totalDeploymentsetReplicas == $runningDeploymentsetReplicas ]; then
			echo "${deploymentset} has been scale up"
			sleep 2
			break
		else
			echo "${deploymentset} is starting."
			sleep 2
		fi
	done
}

if [[ $option == 1 || $option == 2 || $option == 3 ]]; then
	for i in $(cat Choose.txt); do
		kubectl config use-context $i
		status=$(echo $?)
		if [ $status == 0 ]; then
			kubectl get pods | awk '$4 !~ /0/ {print $1}' | awk -F '\t' 'NR>1 && NF=1' >Threshold_Services.txt
			for j in $(cat Threshold_Services.txt); do
				echo $j
				RESTART=$(kubectl get pods $j | awk {'print$4'} | tail -1)
				READY=$(kubectl get pods $j | awk {'print$2'} | tail -1)
				STATUS=$(kubectl get pods $j | awk {'print$3'} | tail -1)
				if [[ $RESTART > 0 ]]; then
					PNAME=$(echo "$j" | awk '{ for(i=length;i!=0;i--) x=(x substr($0,i,1))}{print x;x=""}' | cut -d'-' -f 3- | awk '{ for(i=length;i!=0;i--) x=(x substr($0,i,1))}{print x;x=""}')
					echo $PNAME
					d=$(kubectl get pods | awk '$4 !~ /0/ {print $1}' | awk -F '\t' 'NR>1 && NF=1')
					kubectl get pods | awk '$4 !~ /0/ {print $0}' | awk -F '\t' 'NR>1 && NF=1' | awk '{ for(i=length;i!=0;i--) x=(x substr($0,i,1))}{print x;x=""}' | cut -d'-' -f 3- | awk '{ for(i=length;i!=0;i--) x=(x substr($0,i,1))}{print x;x=""}' >Restart_required_services.txt

					for deploymentset in $(cat Restart_required_services.txt); do
						scaleDown
						scaleUp
					done
				else
					echo "The Pods is not restarted"
				fi
			done
		else
			echo "Unable to use the context $i"
		fi
	done
fi
echo "Do you want to continue with scaling part <y/n> : "

```
