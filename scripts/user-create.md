
Create User using Bash Script

```bash
#!/usr/bin/env bash

echo "enter new username"
read user
echo "enter new passwd"
read pass


sudo useradd -m $user -s /bin/bash -p $pass

```
