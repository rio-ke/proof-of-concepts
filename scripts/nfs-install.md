## Install NFS-server-Script



**_script_**
```bash
#!/usr/bin/env bash
# nfs_install.sh

package=nfs-kernel-server
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
bash nfs_install.sh
```
