#!/usr/bin/env bash
set -ex 
sudo apt update
sudo apt install curl nginx nfs-common -y
sudo systemctl start nginx && sudo systemctl enable nginx