
Create User using Bash Script

```bash
#!/usr/bin/env bash

# user-creation.sh
echo "enter your username"
read USERNAME
echo "enter your password"
read PASSWORD
sudo useradd -m "${USERNAME}" -s /bin/bash -p "${PASSWORD}"
```
execution

```bash
bash user-creation.sh
```
