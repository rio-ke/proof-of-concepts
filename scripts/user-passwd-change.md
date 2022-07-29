## install changepassword-script

**_script_**
```bash

#!/usr/bin/env bash
# changepasswd_install.sh

# Password_change.sh
echo "enter username"
read USERNAME
echo "enter  password"
read PASSWORD
echo $USERNAME:$PASSWORD | sudo chpasswd

```

**_execution_**

```bash
bash changepasswd_install.sh
```
