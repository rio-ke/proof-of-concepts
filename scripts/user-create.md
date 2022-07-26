
Create User using Bash Script

```bash
#!/usr/bin/env bash

# user-creation.sh
echo "enter your username"
read username
echo "enter your password"
read password
sudo useradd -m $username -s /bin/bash -p $password
```
execution

```bash
bash user-creation.sh
```
