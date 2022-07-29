## install mysql -script



**_script_**
```bash
#!/usr/bin/env bash
# mysql_install.sh

package=mysql-server
MISSING=$( dpkg --get-selections ${package} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    echo -e "\e[1;31m${package} is Not installed."
    sudo apt update
    sudo apt install "${package}" -y   

else
    echo -e "\e[1;31m${package} is already installed "

fi
```

**_execution_**

```bash
bash mysql_install.sh
```
