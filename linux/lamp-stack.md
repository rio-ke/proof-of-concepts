
_installation apache2_


```conf
sudo apt install apache2 -y
sudo mkdir /var/www/sbmch.org.in
sudo chmod -R 775 /var/www/sbmch.org.in
echo "sbmch.org.in" | sudo tee  /var/www/sbmch.org.in/index.html
sudo a2dissite 000-default.conf

sudo vim /etc/apache2/sites-available/sbmch.org.in
<VirtualHost *:80>

        ServerAdmin webmaster@sbmch.org.in
        Servername sbmch.org.in
        DocumentRoot /var/www/sbmch.org.in

        ErrorLog ${APACHE_LOG_DIR}/sbmch.org.in.error.log
        CustomLog ${APACHE_LOG_DIR}/sbmch.org.in.access.log combined
        
</VirtualHost>

sudo a2ensite sbmch.org.in.conf
sudo systemctl reload apache2

```

_vsftpd installation_

```service
sudo mkdir -p /etc/vsftpd/users
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.original
```

`sudo vim /etc/vsftpd.conf`

```service
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=NO
idle_session_timeout=600
data_connection_timeout=120
ascii_upload_enable=YES
ascii_download_enable=YES
ftpd_banner=Welcome to sbmch.org.in FTP service.
chroot_local_user=NO
chroot_list_enable=YES
user_config_dir=/etc/vsftpd/users
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
ssl_enable=NO
chroot_list_file=/etc/vsftpd.chroot_list
userlist_enable=YES
userlist_file=/etc/vsftpd.chroot_list
userlist_deny=NO
```

_commands_

```bash
sudo chown -R upload-user:upload-user /var/www/sbmch.org.in
echo "local_root=/var/www/sbmch.org.in" | sudo tee  /etc/vsftpd/users/upload-user
echo "upload-user" | tee  /etc/vsftpd.chroot_list
systemctl restart vsftpd
systemctl status vsftpd
```

_MySQL installation_

```bash
sudo apt install mysql-server -y
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'SmFudW8uaW9AbXlzcWw=';
create database ris_db;
```

_phpadmin configuration_

`sudo nano /etc/dbconfig-common/phpmyadmin.conf`

```conf
#dbc_dbuser='phpmyadmin'
#dbc_dbpass=''
#dbc_dbname='phpmyadmin'
```

```service
sudo dpkg-reconfigure phpmyadmin
sudo systemctl restart apache2
```

_php installation_

```bash
sudo apt install php php-mbstring php-zip php-gd php-json php-curl -y
```

_auto sync file movement_

```bash
sudo apt install inotify-tools
```

_script file_

```bash
#!/usr/bin/env bash

inotifywait -m -r -e create /home/mike/demo |
while read file; do
      cp /home/mike/demo/* /home/mike/final
done
```
