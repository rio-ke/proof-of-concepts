
_**Configuration of Nginx**_

Configure two domains and the document root in this task.

|Domain| document root|
|---|---|
| fourtimes.ml | /var/www/fourtimes |
| dodo-found.tk | /var/www/dodofound |


Nginx is available in Ubuntu’s default repositories,

```bash

sudo apt update
sudo apt install nginx -y

```

create the document root for this vhost configuration

```bash

sudo mkdir -p /var/www/fourtimes.ml
sudo vim /var/www/fourtimes.ml/index.html

```

_sample index page_

```bash

<html>
    <head>
        <title>Welcome to Fourtimes</title>
    </head>
    <body>
        <h1>Success!  The Fourtimes server block is working!</h1>
    </body>
</html>

```


_remove the default domain_

```bash

rm -rf etc/nginx/sites-enabled/default
rm -rf etc/nginx/sites-available/default

```

_SSL Certificate Creation_

We got the SSL from zerossl.com. These are the documents we have.

![image](https://user-images.githubusercontent.com/57703276/170814060-b0817bd0-d722-4d8f-8a25-052965a81130.png)
 
download the file to the target machine and move to target location

**Note- In this example, the content of the certificate.crt and ca_bundle.crt files is copied to a new file and named certificate.crt.***

```bash

mkdir -p /etc/nginx/ssl
cat certificate.crt ca_bundle.crt >> certificate.crt
cp certificate.crt      /etc/nginx/ssl/certificate.crt     
cp private.key          /etc/nginx/ssl/private.key

```


_vhost configuration with http to https redirection_

`/etc/nginx/sites-enabled/fourtimes.ml.conf`

```bash

sudo vim /etc/nginx/sites-enabled/fourtimes.ml.conf

```

`/etc/nginx/sites-enabled/fourtimes.ml.conf`

```

server {
    listen       80;
    server_name  fourtimes.ml www.fourtimes.ml;
    return 301 https://$host$request_uri;
    
    location / {
        root   /var/www/fourtimes.ml;
        index  index.html index.htm;
    }
}

server {
    listen                443 ssl;
    server_name          fourtimes.ml;

    ssl                  on;
    ssl_certificate      /etc/nginx/ssl-certificate/certificate.crt; 
    ssl_certificate_key  /etc/nginx/ssl-certificate/private.key;

    access_log           /var/log/nginx/fourtimes.ml.access.log;
    error_log            /var/log/nginx/fourtimes.ml.error.log;

    location     / {
        root         /var/www/fourtimes.ml;
        index        index.html index.htm;
    }
}

```

_validation the nginx_

```bash
nginx -t
```

_restart the service_

```bash
systemctl restart nginx 
```

It will give your domain secure access. We can get to https://fourtimes.ml using a browser.

---

we consider as a domain `dodo-found`

|Domain| document root|
|---|---|
|dodo-found.tk|/var/www/dodofound|

create the document root for this vhost configuration

```bash
sudo mkdir -p /var/www/dodofound
sudo vim /var/www/dodofound/index.html
```

_sample index page_

```bash

<html>
    <head>
        <title>Welcome to DoDo Found</title>
    </head>
    <body>
        <h1>Success!  The DoDo Found block is working!</h1>
    </body>
</html>

```

_vhost configuration_

`/etc/nginx/sites-enabled/dodo-found.tk.conf`

_SSL Certificate Creation_

We got the SSL from zerossl.com. These are the documents we have.

![image](https://user-images.githubusercontent.com/57703276/170814060-b0817bd0-d722-4d8f-8a25-052965a81130.png)
 
download the file to the target machine and move to tager get location


**Note- In this example, the content of the certificate.crt and ca_bundle.crt files is copied to a new file and named certificate.crt.***

```bash
mkdir -p /etc/nginx/ssl
cat certificate.crt ca_bundle.crt >> certificate.crt
cp certificate.crt      /etc/nginx/ssl/certificate.crt     
cp private.key          /etc/nginx/ssl/private.key
```

_vhost configuration with http to https redirection_

```bash
sudo vim /etc/nginx/sites-enabled/dodo-found.tk.conf
```

`/etc/nginx/sites-enabled/dodo-found.tk.conf`

```bash
server {
    listen       80;
    server_name  dodo-found.tk www.dodo-found.tk;
    return 301 https://$host$request_uri;
    
    location / {
        root   /var/www/dodofound;
        index  index.html index.htm;
    }
}

server {
    listen                443 ssl;
    server_name          dodo-found.tk;
    
    ssl                  on;
    ssl_certificate      /etc/nginx/ssl-certificate/certificate.crt; 
    ssl_certificate_key  /etc/nginx/ssl-certificate/private.key;
   
    access_log           /var/log/nginx/fourtimes.ml.access.log;
    error_log            /var/log/nginx/fourtimes.ml.error.log;

    location     / {
        root         /var/www/dodofound;
        index        index.html index.htm;
    }
}
```

_validation the nginx_

```bash
sudo nginx -t
```

_restart the service_

```bash
sudo systemctl restart nginx 
```

It will give your domain secure access. We can get to https://dodo-found.tk using a browser.

---

### Create a MySQL user and a database, then assign privileges to the database.


We can create a `fourtimes` `dodofound` user and a `fourtimes` `dodofound` database.

|Database|user|password|host|
|---|---|---|---|
|fourtimes|fourtimes|Passwordchanged@123|localhost|
|dodofound|dodofound|Passwordchanged@123|localhost|

_database usage_

* We build the 'fourtimes' database in this part, which can only be accessed by the 'fourtimes' user.

* We build the 'dodofound' database in this part, which can only be accessed by the 'dodofound' user.

```bash

sudo apt update
sudo apt-get install mysql-server -y

```

Create a root password and set privileges in this section.

```bash

sudo mysql_secure_installation

```

To log in with root and a password, go here.

```bash

sudo mysql -u root -p
root password

```

Then create a user and a database, and assign privileges to the database.

_Create fourtimes User and Database_

```bash

CREATE USER 'fourtimes'@'localhost' IDENTIFIED BY 'Passwordchanged@123';
create database fourtimes;
GRANT all ON fourtimes.* TO 'fourtimes'@'localhost';
flush privileges;

```

_Create dodofound User and Database_

```bash
CREATE USER 'dodofound'@'localhost' IDENTIFIED BY 'Passwordchanged@123';
create database dodofound;
GRANT all ON dodofound.* TO 'dodofound'@'localhost';
flush privileges;

```

#### Create a VSFTPD account and give it a specific path to access the user.

---

_user document root create_

|user|password|Path|
|---|---|---|
|fourtimes|a|/var/www/fourtimes|
|dodofound|b|/var/www/dodofound|


_package installation_

```bash

sudo apt update
sudo apt install vsftpd -y

```

_ftp user creation_

```bash

sudo useradd -m -s /bin/bash fourtimes
sudo passwd fourtimes
sudo useradd -m -s /bin/bash dodofound
sudo passwd dodofound

```
**_In this scenario, the vsftpd user can log in via ssh, so the user must be blocked in ssh_**
 
 ```bash
 
 sudo vim /etc/ssh/sshd_config
 
 #add this line last line
 Deny fourtimes, dodofound
 
 ```

_configuration changes_

backup the original file  for future issues.

```bash

sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.original

```

_adjust the configuration according to the needs_

`sudo vim /etc/vsftpd.conf`

```conf
listen                  = YES
listen_ipv6             = NO
anonymous_enable        = NO
local_enable            = YES
write_enable            = YES
local_umask             = 022
dirmessage_enable       = YES
use_localtime           = YES
xferlog_enable          = YES
connect_from_port_20    = YES
xferlog_file            = /var/log/vsftpd.log
xferlog_std_format      = NO
idle_session_timeout    = 600
data_connection_timeout = 120
ascii_upload_enable     = YES
ascii_download_enable   = YES
ftpd_banner             = Welcome to fourtimes.ml FTP service.
chroot_local_user       = NO
chroot_list_enable      = YES
user_config_dir         = /etc/vsftpd/users
allow_writeable_chroot  = YES
secure_chroot_dir       = /var/run/vsftpd/empty
pam_service_name        =vsftpd
rsa_cert_file           =/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file    =/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable              =NO
chroot_list_file        =/etc/vsftpd.chroot_list
```
_create vsftpd users list_

```bash

sudo mkdir -p /etc/vsftpd/users

```

```bash
# first user for fourtimes.ml domain document root

sudo mkdir -p /var/www/fourtimes
sudo chown -R fourtimes:fourtimes /var/www/fourtimes
sudo "local_root=/var/www/fourtimes" | tee  /etc/vsftpd/users/fourtimes
```

```bash
# second user for dodofound.tk domain document root

sudo mkdir -p /var/www/dodofound
sudo chown -R dodofound:dodofound /var/www/dodofound
sudo "local_root=/var/www/dodofound" | tee /etc/vsftpd/users/dodofound

```

_restrict the users at root level_

```bash

sudo echo "fourtimes" | tee  /etc/vsftpd.chroot_list
sudo echo "dodofound" | tee  -a /etc/vsftpd.chroot_list

```

_restart the service_

```bash

sudo systemctl restart vsftpd

```

**Note:**  If the error /home directory does not appear, check your user shell type, delete your user, then create a new user with the `adduser` command.

