## Create the vhost vhost domain nginx?


```bash

#!/usr/bin/env bash
#
set -x

read -p "Enter username : " username
read -p "Enter domain name : " domain

# Functions
ok() { echo -e '\e[32m'$domain'\e[m'; } # Green
die() { echo -e '\e[1;31m'$domain'\e[m'; exit 1; }

# Variables
#NGINX_AVAILABLE_VHOSTS='/etc/nginx/sites-available'
NGINX_ENABLED_VHOSTS='/etc/nginx/sites-enabled'
WEB_DIR='/var/www/html/'
WEB_USER=$username


# Create nginx config file
cat > $NGINX_ENABLED_VHOSTS/$domain-vhost.conf <<EOF
server {
    listen       80;
    server_name  $domain www.$domain;

    
    location / {
        root   /var/www/html/;
        index  index.html index.htm;
    }
}

EOF


# Creating index.html file
cat > $WEB_DIR/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
      	<title>$domain</title>
        <meta charset="utf-8" />
</head>
<body class="container">
        <header><h1>$domain<h1></header>
        <div id="wrapper"><p>Hello World</p></div>
        <footer>© $(date +%Y)</footer>
</body>
</html>
EOF


# Enable site by creating symbolic link
# ln -s $NGINX_AVAILABLE_VHOSTS/$1 $NGINX_ENABLED_VHOSTS/$1

# Host entry for domain
echo "192.168.2.253 $domain" > /etc/hosts

# Restart
echo "Do you wish to restart nginx?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) service nginx restart ; break;;
        No ) exit;;
    esac
done

ok "Site Created for http://$domain"

```


**_Execute run command_**

```bash
bash nginx-vhost-conf.sh
```
