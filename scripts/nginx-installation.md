## Nginx service installation bash script

command

```bash
#!/usr/bin/env bash

# nginx.sh
sudo apt-get -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

executable permission set

```bash 
chmod +x nginx.sh
```

execution

```bash
# with executable permission
./nginx.sh

# with out executable permission
bash nginx.sh
```

