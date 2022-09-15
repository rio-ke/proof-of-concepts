
_commands_

```bash
mkdir /opt/traps/forensics
touch /opt/traps/forensics/1.txt
touch /opt/traps/forensics/2.txt
```

_script_

```bash
#!/bin/bash
# script.sh
set -E -u -o pipefail -e -x
if [ -d "/opt/traps/forensics" ] 
then
    echo "Directory /opt/traps/forensics exists." 
    # rm -rf /opt/traps/forensics
else
    echo "Error: Directory /opt/traps/forensics does not exists."
fi
```

_execution_

```bash
sudo bash script.sh
```


_updated script_

```bash
#!/usr/bin/env bash

set -E -u -o pipefail -e -x
if [ -d "/opt/traps/forensics" ]; then
    echo "Directory /opt/traps/forensics exists."
    # rm -rf /opt/traps/forensics
    if sudo find /opt/traps/forensics/* -type d -mtime +7 -delete -print; then
        echo "Deleting /opt/traps/forensics/ older than 7 days successful"
    else
        echo "sleeping 300 seconds and retrying Deleting /opt/traps/forensics/ older than 7 days"
        sleep 300
        if sudo find /opt/traps/forensics/* -type d -mtime +7 -delete -print; then
            echo "Deleting /opt/traps/forensics/ older than 7 days successful on second attempt"
        else
            echo "sleeping 300 seconds and Deleting /opt/traps/forensics/ older than 7 days"
            sleep 300
            if sudo find /opt/traps/forensics/* -type d -mtime +7 -delete -print; then
                echo "Deleting /opt/traps/forensics/ older than 7 days successful on third attempt"
            else
                echo "Deleting /opt/traps/forensics/ older than 7 days failed on third attempt"
                exit 1
            fi
        fi
    fi
else
    echo "Error: Directory /opt/traps/forensics does not exists."
    exit 0
fi

```

refer 3 modified directory in last 5 minutes in Linux

```bash
#!/usr/bin/env bash

set -E -u -o pipefail -e -x
if [ -d "/opt/traps/forensics" ]; then
    echo "Directory /opt/traps/forensics exists."
    # rm -rf /opt/traps/forensics
    if sudo find /opt/traps/forensics/* -type d -mmin -5 -delete -print; then
        echo "Deleting /opt/traps/forensics/ older than 5 min successful"
    else
        echo "sleeping 300 seconds and retrying Deleting /opt/traps/forensics/ older than 7 days"
        sleep 300
        if sudo find /opt/traps/forensics/* -type d -mmin -5 -delete -print; then
            echo "Deleting /opt/traps/forensics/ older than 5 min successful on second attempt"
        else
            echo "sleeping 300 seconds and Deleting /opt/traps/forensics/ older than 7 days"
            sleep 300
            if sudo find /opt/traps/forensics/* -type d -mmin -5 -delete -print; then
                echo "Deleting /opt/traps/forensics/ older than 5 min successful on third attempt"
            else
                echo "Deleting /opt/traps/forensics/ older than 5 min failed on third attempt"
            fi
        fi
    fi
else
    echo "Error: Directory /opt/traps/forensics does not exists."
    exit 0
fi
```
