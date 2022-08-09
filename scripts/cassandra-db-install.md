## cassandra-db-installation

**script**

```bash

#!/usr/bin/env bash
# cassandra-install.sh

PACKAGE=cassandra
MISSING=$( dpkg --get-selections ${PACKAGE} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    sudo apt install openjdk-8-jdk -y
    sudo apt install apt-transport-https -y
    wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
    sudo sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 311x main" > /etc/apt/sources.list.d/cassandra.list'
    sudo apt update
    sudo apt install cassandra -y
    echo -e "\e[1;31$PACKAGE installation has been installed"
else
    echo -e "\e[1;31m${PACKAGE} is already installed "

fi

```

**execution**

```bash

bash cassandra-install.sh

```
