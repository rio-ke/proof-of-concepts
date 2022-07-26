## apache2 installation bash script

```bash
#!/usr/bin/env bash
# apache2.sh
sudo apt update
sudo apt install apache2 -y
sudo systemctl start nginx
sudo systemctl enable apache2
sudo systemctl status apache2
```

**_bash script execution command_**

```bash
bash apache2.sh
```

