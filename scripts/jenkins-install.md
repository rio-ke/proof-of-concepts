## install jenkins-script

**_script_**

```bash
#!/usr/bin/env bash
# jenkins-install.sh

PACKAGE=jenkins
MISSING=$( dpkg --get-selections ${PACKAGE} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    # -installation.sh
    echo -e "\e[1;31mupdate the respository"
    sudo apt update
    sudo apt install openjdk-11-jdk -y
    sudo apt install wget -y
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
