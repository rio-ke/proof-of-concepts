## docker-compose-installation

**script**

```bash
#!/usr/bin/env bash
# docker-compose-install.sh

PACKAGE=docker-compose
MISSING=$( dpkg --get-selections ${PACKAGE} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    sudo apt update
    sudo apt install curl
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose    sudo apt update
    sudo chmod +x /usr/local/bin/docker-compose
    sudo apt update
    sudo apt install docker-compose -y
    echo -e "\e[1;31$PACKAGE installation has been installed"
else
    echo -e "\e[1;31m${PACKAGE} is already installed "

fi
```

**execution**
```bash

bash docker-compose-install.sh

```
