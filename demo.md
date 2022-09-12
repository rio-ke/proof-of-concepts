
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
