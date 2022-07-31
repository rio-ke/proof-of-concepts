## Nginx service installation bash script

command

```bash
#!/usr/bin/env bash
# apache2.sh

package=nginx
MISSING=$( dpkg --get-selections ${package} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    echo "${package} is Not installed."
    sudo apt update
    sudo apt install "${package}" -y   

else
    echo "${package} is already installed "

fi
```

execution

```bash
# with executable permission
./nginx.sh

# with out executable permission
bash nginx.sh
```

