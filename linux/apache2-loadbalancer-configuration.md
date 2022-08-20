
### Load Balancer Process


 Load balancing is the process of distributing network traffic across multiple servers. This ensures no single server bears too much demand. By spreading the work evenly, load balancing improves application responsiveness. It also increases availability of applications and websites for users.


![Screenshot from 2022-05-30 18-33-53](https://user-images.githubusercontent.com/102893121/170998449-9d31773c-6f59-414d-9db8-5a3c98340c67.png)

---

**_configuration_**

In this section 2 apache container running as a server
  * Apache1
  * Apache2

_create Apache DockerFile_   

**Note:** To create an Apache container, go to this post.


https://github.com/dodo-foundation/linux-learns/blob/69051eab7d4611f7216e0c041f7db3b1e1c991a4/docker-apache2-https.md


Once you've created the Apache2 image, execute it to create two containers with different ports, as seen below.

```bash

docker run -d -p 8081:80 --name Apache1 imageid
docker run -d -p 8082:80 --name Apache2 imageid

```

Check the status of your container's operation.

---

### Apache Configuration file

```bash
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests
```

```bash

sudo vim /etc/apache2/sites-available/load_balance.conf

```
_sample load balance file_

```bash

<VirtualHost *:80>

<Proxy balancer://mycluster>
    BalancerMember http://localhost:8081
    BalancerMember http://localhost:8082
</Proxy>
    ProxyPreserveHost On
    ProxyPass / balancer://mycluster/
    ProxyPassReverse / balancer://mycluster/
</VirtualHost>

```
_**Enable your load_balance.conf file**_

```bash

sudo a2ensite load_balance.conf

OR

ln -s /etc/apache2/sites-available/load_balance.conf /etc/apache2/sites-enabled/

```

_Check ur config_

```bash

sudo apache2ctl -t
sudo systemctl restart apache2.service

```

**Output**

```bash

curl localhost

#Output
# Its works container1
# Its works container2

```
or check ur web browser to `localhost`

---

_**LoadBalancer With SSL**_

We will configure a load balancer with an SSL certificate in this task.

Enable SSL and Rewrite Mode 

```bash

# enable SSL
sudo a2enmod ssl
sudo a2enmod rewrite

```

```bash

#sudo vim /etc/apache2/sites-available/load_balance.conf 
<VirtualHost *:80>

        ServerName http://127.0.0.1:8081
        ServerName http://127.0.0.1:8082

        # Redirect permanent / https://dodo-found.tk/
        RewriteEngine On
        RewriteCond %{HTTPS} off
        RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}

   <Proxy balancer://mycluster>
      BalancerMember http://127.0.0.1:8081
      BalancerMember http://127.0.0.1:8082
    </Proxy>
    ProxyPreserveHost On
    ProxyPass / balancer://mycluster/
    ProxyPassReverse / balancer://mycluster/

</VirtualHost>
<VirtualHost *:443>

        ServerName http://127.0.0.1:8081
        ServerName http://127.0.0.1:8082


        SSLEngine                on
        SSLCertificateFile       /etc/apache2/ssl-dodo/certificate.crt
        SSLCertificateKeyFile    /etc/apache2/ssl-dodo/private.key
        SSLCertificateChainFile  /etc/apache2/ssl-dodo/ca_bundle.crt

   <Proxy balancer://mycluster>
      BalancerMember http://127.0.0.1:8081
      BalancerMember http://127.0.0.1:8082
    </Proxy>
    ProxyPreserveHost On
    ProxyPass / balancer://mycluster/
    ProxyPassReverse / balancer://mycluster/

</VirtualHost>
```

_**Enable your load_balance.conf file**_

```bash

sudo a2ensite load_balance.conf

OR

ln -s /etc/apache2/sites-available/load_balance.conf /etc/apache2/sites-enabled/

```

_Check ur config_

```bash

sudo apache2ctl -t
sudo systemctl restart apache2.service

```
---

**Output**

```bash

curl localhost

#Output
# Its works container1
# Its works container2

```
or check ur web browser to `localhost`

                                                                                          
