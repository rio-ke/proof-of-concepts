## install jenkins-script

**_script_**

```bash

#!/usr/bin/env bash
# jenkins_install.sh

PACKAGE=jenkins
MISSING=$( dpkg --get-selections ${PACKAGE} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    # -installation.sh
    echo -e "\e[1;31mupdate the respository"
    echo "install the curl packages"
    sudo apt install curl -y
    echo "Downlaod the jenkins latest version"
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt update
    sudo apt install $PACKAGE   -y
    echo -e "\e[1;31jenkins installation has been installed"

else
    echo -e "\e[1;31m${PACKAGE} is already installed "

fi

```

**_execution_**

```bash

bash jenkins_install.sh

```
