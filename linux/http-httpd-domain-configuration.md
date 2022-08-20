### Configure nginx - http to https

1. Download the ssl certificate and Extract that.
2. go to the exact path and open in terminal.
3. list the file

```bash
ls
```

![image](https://user-images.githubusercontent.com/91359308/169757062-996321bf-1e8c-44c2-8696-5a68d3baec41.png)

**4. Merge the certificate**

```bash
cat certificate.crt ca_bundle.crt >> certificate.crt

# copy the certificate, paste into  /etc/nginx/ssl-certificate/certificate.crt
cat certificate.crt

# copy the certificate, paste into  /etc/nginx/ssl-certificate/private.key
cat private.key
```

**5. To store the value in nginx**

```bash

mkdir /etc/nginx/ssl-certificate
sudo vim /etc/nginx/ssl-certificate/certificate.crt
sudo vim /etc/nginx/ssl-certificate/private.key

```

**6. configure the https,http domains and redirect conditions**

```bash

vi /etc/nginx/sites-available/fourtimes.ml

add this content:
-----------------
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
    server_name  fourtimes.ml;
    access_log   /var/log/nginx/fourtimes.ml.access.log;
    error_log    /var/log/nginx/fourtimes.ml.error.log;

    location     / {
        root         /var/www/fourtimes.ml;
        index        index.html index.htm;
    }
}

```

**7. Create directory file**

```bash
mkdir /var/www/fourtimes.ml
```

**8. Change the directory**

```bash
cd /etc/nginx/sites-enabled
```

**9. copy the file sites-enabled from site-available**

```bash
ln -s /etc/nginx/sites-available/fourtimes.ml ./
```
**10. Restart the server**

```bash
systemctl restart nginx
```

**11. Status of the server**

```bash
systemctl status nginx
```

**12. Create index.html file and put the information:**

```bash
vim /var/www/fourtimes.ml/index.html

add this content:
-----------------
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-apiign: center;">
welcome to the fourtimes.ml domain
</div>
</body>
</html>
```

**13. To run inside the terminal**

```bash
curl https://fourtimes.ml
```

**14.** **Path routing** - Go to the document root

```bash
cd /var/www/fourtimes.ml/
```

**15. Create new directory**

```bash
mkdir demo
```

**16. Change directory**
```bash
cd demo
```
**17. create index.html file**
```bash 
vim index.html
```
**18. Create index.html file and put the information:**

```bash
vim /var/www/fourtimes.ml/demo/index.html

add this content:
-----------------
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-apiign: center;">
welcome to the demo path routing
</div>
</body>
</html>
```
**Output**

![image](https://user-images.githubusercontent.com/91359308/169807444-35b6d132-fa80-4201-9d9e-8198c9cc882f.png)

![image](https://user-images.githubusercontent.com/91359308/169808713-4dc0d8d5-9c53-44a3-8602-9f942ecef8fa.png)
