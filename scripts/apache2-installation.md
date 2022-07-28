## apache2 installation bash script

```bash

#!/usr/bin/env bash
# apache2.sh

package=apache2
MISSING=$( dpkg --get-selections ${package} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    echo "${package} is Not installed."
    sudo apt update
    sudo apt install "${package}" -y   

else
    echo "${package} is already installed "

fi

```

**_execution command_**

```bash
bash apache2.sh
```
