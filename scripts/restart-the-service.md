
```bash
#!/usr/bin/env bash

serviceName="docker"
serviceStatus=$(sudo systemctl is-active ${serviceName})

if [ $serviceStatus != "active" ]; then
    echo "${serviceName} service is in-active."
    sudo systemctl start "${serviceName}"
else
    echo "${serviceName} service status is ${serviceStatus}"

fi

```
