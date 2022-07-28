## Install MYSQL-Script



**_script_**
```bash
#!/usr/bin/env bash
# mysql_install.sh

package=mysql-server
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
bash mysql_install.sh
```
