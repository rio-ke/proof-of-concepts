## Nginx service installation bash script


**_script run command_**
```bash

sudo vim nginx.sh
```

```bash
sudo systemctl stop apache2

sudo apt-get -y install nginx

sudo systemctl status nginx

```

- permission change to bash script

```bash 
chmod +x nginx.sh
```

**_script run command_**

```bash

./nginx.sh
```
or

```bash
bash nginx.sh
```

