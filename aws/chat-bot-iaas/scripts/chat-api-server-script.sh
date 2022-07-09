#!/usr/bin/env bash
set -ex 

echo ${efsvol}
sudo apt update
sudo apt install curl nfs-common -y
sudo mkdir /data
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efsvol}:/ /data