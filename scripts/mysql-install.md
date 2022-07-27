## Install Mysql-Script

**_File Cretaion_**
```bash

sudo vim mysql-install.sh

```



**_script_**

```bash
#usr/bin/env bash

serviceName="mysql-server"
serviceStatus=$(sudo systemctl is-active ${serviceName})

if [ $serviceStatus != "active" ]; then
    echo "${serviceName} service is not installed."
   echo
   echo
    sudo apt install  "${serviceName}"
    sudo systemctl start mysql.service
    sudo systemctl status mysql.service

else
    echo "${serviceName} service status is ${serviceStatus}"

fi
```


**_execution_**

```bash
bash mysql-install.sh
```

