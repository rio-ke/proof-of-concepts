## Install Postgresql-Script



**_script_**
```bash
#!/usr/bin/env bash
# postgres_install.sh

package=postgresql&&postgresql-contrib
MISSING=$( dpkg --get-selections ${package} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    echo "${package} is Not installed."
    sudo apt update
    sudo apt install "${package}" -y   

else
    echo "${package} is already installed "

fi
```

**_execution_**

```bash
bash postgres_install.sh
```
