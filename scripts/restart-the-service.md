
```bash
#!/usr/bin/env bash

serviceName="docker"
serviceStatus=$(sudo systemctl is-active ${serviceName})

if [ $serviceStatus != "active" ]; then
    echo -e "\e[1;31m${serviceName} service is in-active."
    sudo systemctl start "${serviceName}"
else
    echo -e "\e[1;31m${serviceName} service status is ${serviceStatus}"

fi

```
