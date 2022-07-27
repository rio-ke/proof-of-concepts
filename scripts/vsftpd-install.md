## Install VSFTPD-Script

**_File Cretaion_**
```bash

sudo vim vsftpd_install.sh

```

**_script_**
```bash

#usr/bin/env bash

serviceName="vsftpd"
serviceStatus=$(sudo systemctl is-active ${serviceName})

if [ $serviceStatus != "active" ]; then
    echo "${serviceName} service is not installed."
   echo
   echo
    sudo apt install vsftpd "${serviceName}"
    sudo systemctl status vsftpd
else
    echo "${serviceName} service status is ${serviceStatus}"

fi

```

**_execution_**

```bash

bash vsftpd_install.sh

```
