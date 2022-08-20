## nginx reverse proxy configuration

---

_reverse proxy process_

In addition to being a "basic" web server, and providing static and dynamic content to end-users, Apache httpd (as well as most other web servers) can also act as a reverse proxy server, also-known-as a "gateway" server.

In such scenarios, httpd itself does not generate or host the data, but rather the content is obtained by one or several backend servers, which normally have no direct connection to the external network. As httpd receives a request from a client, the request itself is proxied to one of these backend servers, which then handles the request, generates the content and then sends this content back to httpd, which then generates the actual HTTP response back to the client.

There are numerous reasons for such an implementation, but generally the typical rationales are due to security, high-availability, load-balancing and centralized authentication/authorization. It is critical in these implementations that the layout, design and architecture of the backend infrastructure (those servers which actually handle the requests) are insulated and protected from the outside; as far as the client is concerned, the reverse proxy server is the sole source of all content.


_Enable the Nginx reverse proxy module_


create the domain in the name of domain

```bash

sudo vim /etc/nginx/sites-enabled/reverse.fourtimes.ml.conf

```

use this conf file

```bash

server {
listen 80;
server_name fourtimes.ml;
location / {
proxy_pass http://google.com;
}
    access_log           /var/log/nginx/fourtimes.ml.access.log;
    error_log            /var/log/nginx/fourtimes.ml.error.log;
}

```

_restart the `apache2` service_

```bash
sudo nginx -t
sudo systemctl reload nginx

```

_conslusion_

When you visit the domain 'fourtimes.ml,' your browser will automatically redirect to google.com.

**_reverse proxy with https configuration_**

We got the SSL from zerossl.com. These are the documents we have.

![image](https://user-images.githubusercontent.com/57703276/170814060-b0817bd0-d722-4d8f-8a25-052965a81130.png)
 
download the file to the target machine and move to tager get location

```
cat /Downloads/certificate.crt ca_bundle.crt >> certificate.crt

mkdir -p /etc/nginx/ssl

cp certificate.crt      /etc/nginx/ssl/certificate.crt     
cp private.key          /etc/nginx/ssl/private.key

```

```bash

sudo vim /etc/nginx/sites-enabled/reverse.fourtimes.ml.conf

```

use this conf file

```bash

# HTTP CONFIGURATION

server {
listen 80;
server_name fourtimes.ml;
return 301 https://$host$request_uri;
location / {
proxy_pass http://google.com;
}
    access_log           /var/log/nginx/fourtimes.ml.access.log;
    error_log            /var/log/nginx/fourtimes.ml.error.log;
}



# HTTPS CONFIGURATION

server {
    listen                443 ssl;
    server_name fourtimes.ml;

    location / {
    proxy_pass http://google.com;
    }

    ssl                  on;
    ssl_certificate      /etc/nginx/ssl-certificate/certificate.crt;
    ssl_certificate_key  /etc/nginx/ssl-certificate/private.key;
    server_name          fourtimes.ml;
    access_log           /var/log/nginx/fourtimes.ml.access.log;
    error_log            /var/log/nginx/fourtimes.ml.error.log;

    }
```



_restart the `nginx` service_

```bash

systemctl restart nginx

```

_conslusion_

When you visit the domain 'fourtimes.ml,' you will be automatically redirected to https://fourtimes.ml after being directed to https://ww.google.com.
