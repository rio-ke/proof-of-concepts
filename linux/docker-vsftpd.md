### Docker-custom-images
---
**Docker image details**
|purpose|details|
|---|---|
|operating system| ubuntu |
|service|vsftpd|
|Document Root|/var/www/dodofound|
|Port| 20 & 21|

**_Apache custom image build_**

We build a custom image for VSFTPD configuration in this section.

```bash
sudo mkdir -p vsftpd
sudo vim Dockerfile
```
Basic configuration is presented below; if you wish to adjust any custom levels, do so according to your needs.

```bash
FROM ubuntu
RUN apt update && apt install vsftpd -y 
RUN useradd -m -s /bin/bash dodofound
RUN echo "dodofound:password" | chpasswd
RUN mkdir -p /etc/vsftpd/users /var/www/html/dodo-found.tk /var/run/vsftpd/empty
RUN chown -R dodofound:dodofound /var/www/html/dodo-found.tk
RUN echo "local_root=/var/www/html/dodo-found.tk" | tee -a /etc/vsftpd/users/dodofound
RUN echo "dodofound" | tee -a /etc/vsftpd.chroot_list
COPY vsftpd.conf /etc/vsftpd.conf
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
```
---

**_vsftpd.conf file_**

_To create an dodo-found config file in your vsftpd directory_

```bash
vim vsftpd/vsftpd.conf
```

```bash
# sudo vim /etc/vsftpd.conf
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
ftpd_banner=Welcome to fourtimes.ml FTP service.
chroot_local_user=NO
chroot_list_enable=YES
user_config_dir=/etc/vsftpd/users
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
chroot_list_file=/etc/vsftpd.chroot_list
```
---

**_Build the vsftpd custom image_**
```bash
docker build -t vsftpd:v1.0 .
```

**_docker run commands_**

```bash
docker run -d -p (localhost_port):(container_port) --name (containername) (imagename)
ex:
docker run -d -p 20:20 -p 21:21 --name vsftpd vsftpd:v1.0
```

Use the command below to see if your container is running or not and check logs and inspect your container and enter your container

```bash
docker ps -a
docker logs (container id)
docker inspect (container id)
docker exec -ti (container id) bash
```
---


**_OUTPUT_**

Use this link to download the file ----> https://filezilla-project.org/
or 
login using

``bash
ftp -p container ip
```

To find container ip use

```bash
docker inspect containr id
```

