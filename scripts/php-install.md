## install php-script



**_script_**
```bash
#!/usr/bin/env bash
# php_install.sh



package=php
MISSING=$( dpkg --get-selections ${package} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    echo -e "\e[1;31m${package} is Not installed."
    sudo apt update
    sudo apt install "${package}" -y
    sudo apt install libapache2-mod-php
    
else
    echo -e "\e[1;31m${package} is already installed "

fi
```

**_execution_**

```bash
bash php_install.sh
```
