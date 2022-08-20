## nginx configuration

---

**What is Nginx?**

Nginx (pronounced ‘engine X’) is an alternative to Apache and is considered to be one of the most popular HTTP web servers in the world. As opposed to Apache, Nginx tends to consume fewer resources and improves server responsiveness. Its event-driven design is what makes it resource-friendly.

Above all, it allows admins to set up advanced configurations and can deal with a high load of concurrent connections. Besides being a good fit for an HTTP web server, Nginx also works as a reverse proxy, load balancer, and standard mail server.


**Requirements**

  | SERVER 	       |  IPADDRESS |
  | --- | --- |
  | Ubuntu 	       |  192.168.0.10 |

_**NGINX Installation**_

Nginx is available in Ubuntu’s default repositories, it is possible to install it from these repositories using the apt packaging system.

```bash
sudo apt update
sudo apt install nginx -y
```

_**NGINX installation verification**_

after instaling the nginx package, use this commmand to verification the nginx package

```bash
nginx -v
```

_**Configuration of Nginx**_

we consider as a domain `fourtims.ml`

create the document root for this vhost configuration

```bash

sudo mkdir -p /var/www/fourtimes.ml
sudo vim /var/www/fourtimes.ml/index.html

```

_remove the default domain_

Take a backup before deleting the default package.

```bash
rm -rf etc/nginx/sites-enabled/default
rm -rf etc/nginx/sites-available/default
```
_vhost configuration_

`/etc/nginx/sites-enabled/fourtimes.ml.conf`

```conf

server {
    listen       80;
    server_name  fourtimes.ml www.fourtimes.ml;
    
    access_log           /var/log/nginx/fourtimes.ml.access.log;
    error_log            /var/log/nginx/fourtimes.ml.error.log;
    
    
    location / {
        root   /var/www/fourtimes.ml;
        index  index.html index.htm;
    }
}

```

_creation of a symlink_

```bash
sudo ln -s /etc/nginx/sites-available/fourtimes.ml.conf /etc/nginx/sites-enabled/
```

_validation the nginx_

```bash
nginx -t
```

_restart the service_

```bash
systemctl stop nginx
systemctl start nginx 
```

It will give your domain insecure access. We can get to http://fourtimes.ml using a browser.


_ssl and http to https redirection_

`/etc/nginx/sites-enabled/fourtimes.ml.conf`

```bash

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
    ssl                  on;
    ssl_certificate      /etc/nginx/ssl-certificate/certificate.crt; 
    ssl_certificate_key  /etc/nginx/ssl-certificate/private.key;
    server_name          fourtimes.ml;
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
systemctl stop nginx
systemctl start nginx 
```

We can validate the domain using http or https in your browser. If you visit the domain http, it will automatically redirect to https://fourtimes.ml.




**NOTE**: In this case, we are utilising the freenom and zerossl procedures.
