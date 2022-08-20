#### apache-reverse-proxy-configuration.md

---

_reverse proxy process_

In addition to being a "basic" web server, and providing static and dynamic content to end-users, Apache httpd (as well as most other web servers) can also act as a reverse proxy server, also-known-as a "gateway" server.

In such scenarios, httpd itself does not generate or host the data, but rather the content is obtained by one or several backend servers, which normally have no direct connection to the external network. As httpd receives a request from a client, the request itself is proxied to one of these backend servers, which then handles the request, generates the content and then sends this content back to httpd, which then generates the actual HTTP response back to the client.

There are numerous reasons for such an implementation, but generally the typical rationales are due to security, high-availability, load-balancing and centralized authentication/authorization. It is critical in these implementations that the layout, design and architecture of the backend infrastructure (those servers which actually handle the requests) are insulated and protected from the outside; as far as the client is concerned, the reverse proxy server is the sole source of all content.

_A typical implementation is below_

![image](https://user-images.githubusercontent.com/57703276/170813018-f09b2467-7f12-44c7-9873-26741706e406.png)

_Enable the apache2 reverse proxy module_

```bash

sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests

```


create the domain in the name of domain

```bash

sudo vim /etc/apache2/sites-available/reverse.fourtimes.ml.conf

```

use this conf file

```bash

<VirtualHost *:80>

        # Domain mapping section
        ServerAdmin webmaster@fourtimes.ml
        Servername fourtimes.ml
        
        # Reverse proxy configuration
        ProxyPass "/"  "http://www.google.com/"
        ProxyPassReverse "/"  "http://www.google.com/"
        
        # Logs location
        ErrorLog ${APACHE_LOG_DIR}/fourtimes.ml.error.log
        CustomLog ${APACHE_LOG_DIR}/fourtimes.ml.access.log combined
        
</VirtualHost>

```

enable the site location

```bash

a2ensite reverse.fourtimes.ml.conf

```

_restart the `apache2` service_

```bash

systemctl restart apache2

```


_conslusion_

When you visit the domain 'fourtimes.ml,' your browser will automatically redirect to google.com.

**_reverse proxy with https configuration_**

We got the SSL from zerossl.com. These are the documents we have.

![image](https://user-images.githubusercontent.com/57703276/170814060-b0817bd0-d722-4d8f-8a25-052965a81130.png)
 
download the file to the target machine and move to tager get location

```

mkdir -p /etc/apache2/ssl
cp ca_bundle.crt        /etc/apache2/ssl/ca_bundle.crt
cp certificate.crt      /etc/apache2/ssl/certificate.crt     
cp private.key          /etc/apache2/ssl/private.key

```

```bash

sudo vim /etc/apache2/sites-available/reverse.fourtimes.ml.conf

```

use this conf file

```bash

# HTTP CONFIGURATION

<VirtualHost *:80>

        ServerAdmin webmaster@fourtimes.ml
        Servername fourtimes.ml
        
        # Redirect permanent / https://fourtimes.ml/
        RewriteEngine On
        RewriteCond %{HTTPS} off
        RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
        
        ErrorLog ${APACHE_LOG_DIR}/fourtimes.ml.error.log
        CustomLog ${APACHE_LOG_DIR}/fourtimes.ml.access.log combined
        
</VirtualHost>

# HTTPS CONFIGURATION

<VirtualHost *:443>

        ServerAdmin webmaster@fourtimes.ml
        Servername fourtimes.ml

        ProxyPass "/"  "http://www.google.com/"
        ProxyPassReverse "/"  "http://www.google.com/"

        SSLEngine                on
        SSLCertificateFile       /etc/apache2/ssl/certificate.crt
        SSLCertificateKeyFile    /etc/apache2/ssl/private.key
        SSLCertificateChainFile  /etc/apache2/ssl/ca_bundle.crt

        ErrorLog ${APACHE_LOG_DIR}/fourtimes.ml.error.log
        CustomLog ${APACHE_LOG_DIR}/fourtimes.ml.access.log combined
        
</VirtualHost>
```


_Enable the site location_


```bash

a2enmod rewrite
a2ensite reverse.fourtimes.ml.conf

```

_restart the `apache2` service_

```bash

systemctl restart apache2

```

_conslusion_

When you visit the domain 'fourtimes.ml,' you will be automatically redirected to https://fourtimes.ml after being directed to https://ww.google.com.
