# network bonding configuration

# Network bonding configuration for CentOS 7


**Bonding configuration type**

There are 7 types of Network Bonding:

* mode=0 (Balance Round Robin)
* mode=1 (Active backup) ⇒ Explained in this below section
* mode=2 (Balance XOR)
* mode=3 (Broadcast)
* mode=4 (802.3ad)
* mode=5 (Balance TLB)
* mode=6 (Balance ALB)

**Configure Bond0 Interface**

* In CentOS 7, the bonding module is not loaded by default. Enter the following command as root user to enable it.

```bash
modprobe --first-time bonding
```

* You can view the bonding module information using command:

```bash
modinfo bonding
```

login as root user now

```bash
sudo -i
```

**Create bond0 configuration file:**

```bash
vi /etc/sysconfig/network-scripts/ifcfg-bond0
```

- Add the following lines

```bash
DEVICE=bond0
NAME=bond0
TYPE=Bond
BONDING_MASTER=yes
IPADDR=192.168.x.11
PREFIX=24
GATEWAY=192.168.x.1
DNS1=192.168.x.x
DNS2=8.8.8.8
ONBOOT=yes
BOOTPROTO=none
BONDING_OPTS="mode=1 primary=em1 miimon=100"
ZONE=public
```
*bond1 configuration*

```bash
DEVICE=bond1
NAME=bond1
TYPE=Bond
BONDING_MASTER=yes
IPADDR=192.168.x.10
PREFIX=24
GATEWAY=192.168.x.1
DNS1=192.168.x.x
DNS2=8.8.8.8
ONBOOT=yes
BOOTPROTO=none
BONDING_OPTS="mode=1 primary=em3 miimon=100"
ZONE=public
```

**Configure Network interfaces**

- we should modify both(emp1 & 1mp3) configuration files

- Edit file in ifcfg-em1 and ifcfg-em3


**_create UUID for the network interface config_**

- select the network interface as eth01 or bond0

then try below commad

```bash
nmcli conn show eth01
```

**_To change the network interface UUID_**

```bash
uuidgen ifcfg-bond0 
#
uuidgen ifcfg-eth01
```
- go to configuration folder

```bash
vi /etc/sysconfig/network-scripts/ifcfg-em1
```

```bash
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=em1
UUID=43a594cd-ec25-48c8-83de-86a875413482 #(if changed)
DEVICE=em1
ONBOOT=yes
MASTER=bond0
SLAVE=yes
ZONE=public
```
* edit-em3 file

```bash
vi /etc/sysconfig/network-scripts/ifcfg-em1
```

```bash
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=em3
UUID=c8b660e0-4430-49de-8067-f897d1fa7610  #(if changed)
DEVICE=em3
ONBOOT=yes
MASTER=bond1
SLAVE=yes
ZONE=public
```



**activate the Network interfaces.**

```bash
ifup ifcfg-em1
ifup ifcfg-em3
```

* enter the following command to make Network Manager aware the changes.


```bash
nmcli con reload
```

* Restart network service to take effect the changes.

```bash
systemctl restart network
```

**Test Network Bonding**

- enter the following command to check whether the bonding interface bond0 is up and running:


```bash
cat /proc/net/bonding/bond0
```

`END`

