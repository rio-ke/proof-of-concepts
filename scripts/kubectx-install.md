## kubectx-install.sh

**script**

```bash
#!/usr/bin/env bash
# kubectx-install.sh

PACKAGE=kubectx
MISSING=$( dpkg --get-selections ${PACKAGE} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    # -installation.sh
    echo -e "\e[1;31mupdate the respository"
    echo "deb [trusted=yes] http://ftp.de.debian.org/debian buster main" | sudo tee -a /etc/apt/sources.list
    sudo apt update
    sudo apt install -y kubectx
    echo -e "\e[1;31$PACKAGE installation has been installed"
else
    echo -e "\e[1;31m${PACKAGE} is already installed "

fi
```

**execution**

```bash

bash kubectx-install.sh

```
