## keepalived configuration

Keepalived is a piece of software which can be used to achieve high availability by assigning two or more nodes a virtual IP and monitoring those nodes, failing over when one goes down. Keepalived can do more, like load balancing and monitoring, but this tutorial focusses on a very simple setup, just IP failove

![image](https://assets.digitalocean.com/articles/high_availability/ha-diagram-animated.gif)

**_requirments_**

|IP|OS|HOSTNAME|
|---|---|---|
|192.168.0.105|Ubuntu|Server1|
|192.168.0.109|Ubuntu|Server2|
|192.168.0.110|Ubuntu|virtual-ip|

_**Pre-steps**_

connect the `each machine` and execute the host entry

```bash
echo "192.168.0.105 Server1" | sudo tee -a /etc/hosts
echo "192.168.0.109 Server2" | sudo tee -a /etc/hosts
```

**_Installation process_**

 Check whether we installed the service in the system before installing the packages.

```bash

dpkg --list | grep keepalived

```
_**Install keepalived service**_

```bash

sudo apt-get update
sudo apt-get install keepalived -y

```
_**Configure KeepAlived**_

Once KeepAlived package is installed, create the main configuration file `/etc/keepalived/keepalived.conf` with below configuration. Replace the Highlighted values as per your configurations.

```bash
vim /etc/keepalived/keepalived.conf
```

_**Set up the ha-proxy-a as a master keepalived.**_

Check that your interface name, According to the configuration. In this case, I'm using 'wlp1s0' as an interface.

```bash
# configuation for the virtual interface
vrrp_instance VI_1 {
    state MASTER
    interface wlp1s0
    virtual_router_id 101
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.0.110
    }
}
```
_**Restart the service**_

```bash
sudo systemctl restart keepalived
sudo systemctl start keepalived
sudo systemctl status keepalived
```
**_Installation process_**


 Check whether we installed the service in the system before installing the packages.

```bash

dpkg --list | grep keepalived

```
_**Install keepalived service**_

```bash

sudo apt-get update
sudo apt-get install keepalived -y

```
_**Configure KeepAlived**_

Once KeepAlived package is installed, create the main configuration file `/etc/keepalived/keepalived.conf` with below configuration. Replace the Highlighted values as per your configurations.

```bash
vim /etc/keepalived/keepalived.conf
```

_**Set up the ha-proxy-b as a backup keepalived.**_

Check that your interface name, According to the configuration. In this case, I'm using 'wlp1s0' as an interface.

```bash
vrrp_instance VI_1 {
    state BACKUP
    interface wlp1s0
    virtual_router_id 101
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.0.110
    }
}
```

_**Start keepalived service**_

```bash
sudo systemctl restart keepalived
sudo systemctl start keepalived
sudo systemctl status keepalived
```
