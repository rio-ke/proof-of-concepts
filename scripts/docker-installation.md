## Installing docker with shell script 

```bash
#!/user/bin/env bash

echo "remove older versions"
sudo apt remove docker docker-engine docker.io containerd runc

echo "Docker’s official GPG key"
sudo apt update -y && \
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
echo "install docker repo latest"
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "install specific docker version"
echo "list verssions"
apt-cache madison docker-ce
echo "install specific version"
sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io


```

**_bash run command_**

```bash

bash docker.sh

```
