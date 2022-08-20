### Docker-custom-images
---
**Docker image details**
|purpose|details|
|---|---|
|operating system| ubuntu |
|server|nginx|
|Document Root|/var/www/dodo-found.tk|
|Port| 80 |

**_Nginx custom image build_**

We build a custom image for nginx without SSL configuration in this section.

```bash
sudo mkdir -p nginx 
sudo vim /nginx/Dockerfile
```
Basic configuration is presented below; if you wish to adjust any custom levels, do so according to your needs.

```bash
FROM ubuntu:latest
RUN apt update && apt install nginx -y
RUN mkdir -p /var/www/html/dodo-found.tk
COPY index.html /var/www/html/dodo-found.tk/index.html
RUN rm -rf etc/nginx/sites-enabled/default

# COPY THE DOMAIN NAME
COPY dodo-found.tk.conf /etc/nginx/sites-enabled/dodo-found.conf

# to show the output file into docker output

RUN ln -sf /dev/stdout /var/log/nginx/dodo-found.tk.access.log \
        && ln -sf /dev/stderr /var/log/nginx/dodo-found.tk.error.log

CMD ["nginx", "-g", "daemon off;"]
```
---

**_index.html file_**

_To create an index file in your nginx directory_

```bash
sudo vim nginx/index.html
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

_To create an dodo-found config file in your nginx directory_

```bash
vim nginx/dodo-found.tk.conf
```

```bash
server {
    listen       80;
    server_name  dodo-found.tk;
    

    location / {
        root   /var/www/html/dodo-found.tk/;
        index  index.html index.htm;
    }
}

```
---

**_Build the nginx custom image_**
```bash
docker build -t nginx:v1.0 .
```

**_docker run commands_**

```bash
docker run -d -p (localhost_port):(container_port) --name (containername) (imagename)
ex:
docker run -d -p 8080:80 --name nginx nginx:v1.0
```

Use the command below to see if your container is running or not and check logs and inspect your container and enter your container

```bash
docker ps -a
docker logs (container id)
docker inspect (container id)
docker exec -ti (container id) bash
```
---

**Nginx with SSL config**

We build a custom image for nginx with SSL configuration in this section.Use zerossl.com to create an SSL certificate for your domain.

```bash
sudo mkdir -p nginx 
sudo vim Dockerfile
```

Basic configuration is presented below; if you wish to adjust any custom levels, do so according to your needs.

```bash
FROM ubuntu:latest
RUN apt update && apt install nginx -y
RUN mkdir -p /var/www/html/dodo-found.tk
COPY index.html /var/www/html/dodo-found.tk/index.html
RUN rm -rf etc/nginx/sites-enabled/default

# COPY THE DOMAIN NAME
COPY dodo-found.conf /etc/nginx/sites-enabled/dodo-found.tk.conf

# to show the output file into docker output

RUN ln -sf /dev/stdout /var/log/nginx/dodo-found.tk.access.log \
        && ln -sf /dev/stderr /var/log/nginx/dodo-found.tk.error.log

#ssl config
RUN mkdir -p /etc/nginx/ssl-certificate/
COPY certificate.crt /etc/nginx/ssl-certificate/
COPY private.key /etc/nginx/ssl-certificate/

CMD ["nginx", "-g", "daemon off;"]
```
---

**_index.html file_**

to create the index file on your nginx folder

```bash
sudo vim nginx/index.html
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

to create the Config file on your nginx folder

```bash
vim nginx/dodo-found.conf
```

Use https://zerossl.com to create an SSL certificate for your domain.

To see this page, upload your SSL certificate to your config file —> https://help.zerossl.com/hc/en-us/sections/360012132973-Installation

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

**_Build the nginx custom image_**
```bash
docker build -t nginx:v1.0 .
```

**_docker run commands_**

```bash
docker run -d -p (localhost_port):(container_port) --name (containername) (imagename)
ex:
docker run -d -p 8080:80 --name nginx nginx:v1.0
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




