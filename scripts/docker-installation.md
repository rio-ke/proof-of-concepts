## Installing docker with shell script 

```bash
#!/user/bin/env bash
# docker.sh

if [ ! -x /var/lib/docker ]; then
     echo "Certificates and docker key" | sudo apt install apt-transport-https ca-certificates curl software-properties-common
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
     echo " system update " | sudo apt update
     apt-cache policy docker-ce
    echo "Installation" | sudo apt install docker-ce
     echo "docker successfully installed"
else
   echo "DOCKER ALREADY INSTALLED"  
fi
```

**_bash run command_**

```bash
bash docker.sh
```
