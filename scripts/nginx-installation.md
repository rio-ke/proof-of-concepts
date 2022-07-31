## Nginx service installation bash script

command

```bash
#!/usr/bin/env bash

# nginx.sh
sudo apt -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

execution

```bash
# with executable permission
./nginx.sh

# with out executable permission
bash nginx.sh
```

