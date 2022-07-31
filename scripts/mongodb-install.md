# install mongodb-script

# **_script_**

```bash

# !/usr/bin/env bash
# mongodb-install.sh

PACKAGE=mongodb-org 
MISSING=$( dpkg --get-selections ${PACKAGE} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    # -installation.sh
    echo -e "\e[1;31mupdate the respository"
    echo "install the additional packages"
    sudo apt install -y software-properties-common gnupg apt-transport-https ca-certificates
    sudo apt update
    echo "Downlaod the mongodb latest version"
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
    sudo apt update
    sudo apt install $PACKAGE   -y
    echo -e "\e[1;31mongodb installation has been installed"
    sudo systemctl start mongod
else
    echo -e "\e[1;31m${PACKAGE} is already installed "

fi

```

**_execution_**

```bash

bash mongodb-install.sh

```
