## Install VSFTPD-Script



**_script_**
```bash
#!/usr/bin/env bash
# vsftpd_install.sh

serviceName="vsftpd"
serviceStatus=$(sudo systemctl is-active ${serviceName})

if [ $serviceStatus != "xxxx" ]; then
    echo "${serviceName} service is not installed."
    echo
    echo
    sudo apt install vsftpd "${serviceName}" -y
    sudo systemctl start vsftpd
else
    echo "${serviceName} service status is ${serviceStatus}"

fi
```

**_execution_**

```bash
bash vsftpd_install.sh
```
