## install redis-script

**_script_**

```bash

#!/usr/bin/env bash
# redis_install.sh

PACKAGE=redis-server
MISSING=$( dpkg --get-selections ${PACKAGE} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    echo -e "\e[1;31m${PACKAGE} is Not installed."
    sudo apt update
    sudo apt install "${PACKAGE}" -y   
else
    echo -e "\e[1;31m${PACKAGE} is already installed "
fi

```

**_execution_**

```bash

bash redis_install.sh

```
