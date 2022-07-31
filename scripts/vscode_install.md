## install vscode-script

**_script_**

```bash

#!/usr/bin/env bash
# vscode_install.sh

PACKAGE=code
MISSING=$( dpkg --get-selections ${PACKAGE} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    # -installation.sh
    echo -e "\e[1;31mupdate the respository"
    sudo apt update
    sudo apt install wget -y
    echo "Downlaod the vscode latest version"
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -"
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install code -y
    echo -e "\e[1;31vscode installation has been installed"

else
    echo -e "\e[1;31m${PACKAGE} is already installed "

fi

```

**_execution_**

```bash

bash vscode_install.sh

```
