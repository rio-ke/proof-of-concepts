#!/usr/bin/env bash
sudo apt update
sudo apt install curl -y
curl -L https://raw.githubusercontent.com/FourTimes/Kubernetes/master/kubeadm-docker-install.sh | sudo bash
sudo docker run -d -p 8080:8080 --name node-apis jjino/node-server-app