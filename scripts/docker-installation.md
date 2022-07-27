## Installing docker with shell script 

```bash

#!/usr/bin/env bash

set -x

echo "remove older versions"
sudo apt remove docker docker-engine docker.io containerd runc

echo "Setup the repository"
sudo apt update -y && \
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common

echo "Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg \
      --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
echo "install docker repo latest"
sudo apt install -y docker-ce docker-ce-cli containerd.io

```

**_bash run command_**

```bash

bash docker.sh

```
