### Docker-custom-images
---
**Docker image details**
|purpose|details|
|---|---|
|operating system| ubuntu |
|server|apache2|
|Document Root|/var/www/dodofound|
|Port| 80 |

**_Apache custom image build_**

We build a custom image for apache2 without SSL configuration in this section.

```bash
sudo mkdir -p apache2
sudo vim Dockerfile
```
Basic configuration is presented below; if you wish to adjust any custom levels, do so according to your needs.

```bash
FROM ubuntu:latest
RUN apt update && apt install apache2 -y

#create the Dockument Root
RUN mkdir -p /var/www/dodofound
RUN echo "It's works" | tee /var/www/dodofound/index.html
RUN ln -sf /dev/stdout /var/log/apache2/dodo-found.access.log \
        && ln -sf /dev/stderr /var/log/apache2/dodo-found.error.log

#Apache config
COPY dodo-found.conf /etc/apache2/sites-available/dodofound.conf
RUN a2dissite 000-default.conf
RUN rm -rf /etc/apache2/sites-available/000-default.conf
RUN a2ensite dodofound.conf 

CMD ["apachectl","-D","FOREGROUND"]
```
---

**_index.html file_**

_To create an index file in your apache2 directory_

```bash
sudo vim apache2/index.html
```

```bash
<html>
    <head>
        <title>Welcome to DoDo Foundation!</title>
    </head>
    <body>
        <h1>Success!  The DoDo Founadtion virtual host is working!</h1>
    </body>
</html>
```
---
**_dodo-found.conf file_**

_To create an dodo-found config file in your apache2 directory_

```bash
vim apache2/dodo-found.conf
```

```bash
<VirtualHost *:80>

        ServerAdmin webmaster@dodo-found.tk
        Servername dodo-found.tk 
        DocumentRoot /var/www/dodofound

        ErrorLog ${APACHE_LOG_DIR}/dodo-found.tk.error.log
        CustomLog ${APACHE_LOG_DIR}/dodo-found.tk.access.log combined
</VirtualHost>
```
---

**_Build the apache custom image_**
```bash
docker build -t apache:v1.0 .
```

**_docker run commands_**

```bash
docker run -d -p (localhost_port):(container_port) --name (containername) (imagename)
ex:
docker run -d -p 8080:80 --name apache apache:v1.0
```

Use the command below to see if your container is running or not and check logs and inspect your container and enter your container

```bash
docker ps -a
docker logs (container id)
docker inspect (container id)
docker exec -ti (container id) bash
```
---

**Apache with SSL config**

We build a custom image for nginx with SSL configuration in this section.Use zerossl.com to create an SSL certificate for your domain.

```bash
sudo mkdir -p apache2 
sudo vim Dockerfile
```

Basic configuration is presented below; if you wish to adjust any custom levels, do so according to your needs.

Use https://zerossl.com to create an SSL certificate for your domain.

To see this page, upload your SSL certificate to your config file —> https://help.zerossl.com/hc/en-us/sections/360012132973-Installation

```bash
FROM ubuntu:latest
RUN apt update && apt install apache2 -y

#create the Dockument Root
RUN mkdir -p /var/www/dodofound
RUN echo "It's works" | tee /var/www/dodofound/index.html

#ssl conf
RUN a2enmod ssl
COPY ca_bundle.crt /etc/ssl/
COPY certificate.crt /etc/ssl/
RUN mkdir -p /etc/ssl/privates
COPY private.key /etc/ssl/privates/

RUN ln -sf /dev/stdout /var/log/apache2/dodo-found.access.log \
        && ln -sf /dev/stderr /var/log/apache2/dodo-found.error.log

#Apache config
COPY dodo_found.conf /etc/apache2/sites-available/dodofound.conf
RUN a2dissite 000-default.conf
RUN rm -rf /etc/apache2/sites-available/000-default.conf
RUN a2ensite dodofound.conf 

CMD ["apachectl","-D","FOREGROUND"]
```
---

**_index.html file_**

to create the index file on your nginx folder

```bash
sudo vim apache2/index.html
```

```bash
<html>
    <head>
        <title>Welcome to DoDo Foundation!</title>
    </head>
    <body>
        <h1>Success!  The DoDo Founadtion virtual host is working!</h1>
    </body>
</html>
```
---

**_dodo-found.conf file_**

to create the Config file on your apache2 folder

```bash
vim apache2/dodo-found.conf
```

```bash

server {
    listen       80;
    server_name  dodo-found.tk;
    return 301 https://dodo-found.tk;

    location / {
        root   /var/www/html/dodo-found.tk/;
        index  index.html index.htm;
    }
}

server {
    listen                443 ssl;
    ssl                  on;
    ssl_certificate      /etc/nginx/ssl-certificate/certificate.crt;
    ssl_certificate_key  /etc/nginx/ssl-certificate/private.key;
    server_name          dodo-found.tk;
    access_log           /var/log/nginx/dodo-found.tk.access.log;
    error_log            /var/log/nginx/dodo-found.tk.error.log;

    location     / {
        root         /var/www/html/dodo-found.tk/;
        index        index.html index.htm;
    }
}                                                                                                                                                    
```

**_Build the apache custom image_**
```bash
docker build -t apache:v1.0 .
```

**_docker run commands_**

```bash
docker run -d -p (localhost_port):(container_port) --name (containername) (imagename)
ex:
docker run -d -p 8080:80 --name apache napache:v1.0
```
---
Add your domain to the host section of your base computer.

```
sudo vim /etc/hosts
17.12.0.1   dodo-found.tk
```
**_OUTPUT_**

```bash
curl -k https://dodo-found.tk
```
or browse your domain name --> https://dodo-found.tk 




