#!/usr/bin/env bash

echo -e "\e[1;31mUpdate the system!"
sudo apt update
sudo apt install curl -y
echo -e "\e[1;31mInstall the compose CLI plugin!"
sudo curl -SL https://github.com/docker/compose/releases/download/v2.7.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
echo -e "\e[1;31mApply executable permissions"
sudo chmod +x /usr/local/bin/docker-compose
echo -e "\e[1;31mdocker version"
docker-compose version
