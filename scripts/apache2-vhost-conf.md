## apache2-vhost-conf


```bash

#!/usr/bin/env bash
#apache2-vhost.sh

#set -x

read -p "Enter username : " USERNAME
read -p "Enter domain name : " DOMAIN
READ -P "Enter your Host Entry IP : " HOSTIP

# Functions
ok() { echo -e '\e[32m'$DOMAIN'\e[m'; } # Green
die() { echo -e '\e[1;31m'$DOMAIN'\e[m'; exit 1; }

# Variables
#APACHE_AVAILABLE_VHOSTS='/etc/apache2/sites-available'
APACHE_ENABLED_VHOSTS='/etc/apache2/sites-available'
WEB_DIR='/var/www/html/'
WEB_USER=$username


# Create nginx config file
cat > $APACHE_ENABLED_VHOSTS/$DOMAIN-vhost.conf <<EOF
server {
    listen       80;
    server_name  $DOMAIN www.$DOMAIN;

    
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
      	<title>$DOMAIN</title>
        <meta charset="utf-8" />
</head>
<body class="container">
        <header><h1>$DOMAIN<h1></header>
        <div id="wrapper"><p>Hello World</p></div>
        <footer>© $(date +%Y)</footer>
</body>
</html>
EOF


# Enable site by creating symbolic link
  a2ensite $APACHE_ENABLED_VHOSTS

# Host entry for domain
  echo "$HOSTIP $DOMAIN" >> /etc/hosts

# Restart
echo "Do you wish to restart apache?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) service apache2 restart ; break;;
        No ) exit;;
    esac
done

echo -e '\e[32m Site Created and Check that the URL http://deva.com\e[m'


```

**_execution command_**

```bash
bash apache2-vhost.sh
```
