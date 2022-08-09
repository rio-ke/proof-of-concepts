## terraform-installation

**script**

```bash
#!/usr/bin/env bash
# terraform-install.sh

PACKAGE=terraform
MISSING=$( dpkg --get-selections ${PACKAGE} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    sudo apt update
    sudo apt install curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt update
    sudo apt install terraform
    echo -e "\e[1;31$PACKAGE installation has been installed"
else
    echo -e "\e[1;31m${PACKAGE} is already installed "

fi
```

**execution**
```bash

bash terraform-install.sh

```
