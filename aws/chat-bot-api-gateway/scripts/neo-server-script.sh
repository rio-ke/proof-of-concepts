#!/usr/bin/env bash
set -ex 
echo ${efsvol}
sudo apt update
sudo apt install curl nfs-common -y
sudo mkdir -p /data
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efsvol}:/ /data
curl -L https://raw.githubusercontent.com/FourTimes/Kubernetes/master/kubeadm-docker-install.sh | sudo bash
sudo docker run -d -p 8080:8080 --name node-apis jjino/node-server-app