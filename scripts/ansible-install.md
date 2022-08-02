## install ansible-script

**_script_**
```bash
#!/usr/bin/env bash
# ansible-install.sh

package=ansible
MISSING=$( dpkg --get-selections ${package} 2>&1 | grep 'install' | awk '{ print $2 }')

if  [ install != "$MISSING" ]; then
    echo -e "\e[1;31m${package} is Not installed."
    sudo apt update
    sudo apt install software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible -y
else
    echo -e "\e[1;31m${package} is already installed "
fi
```

**_execution_**

```bash
bash ansible-install.sh
```

[Referece documentation](https://docs.ansible.com/ansible/2.9/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)
