## pcs-cluster-install-centos


|Server1|IP|username|
|---|---|---|
|node1.example.com|192.168.0.102|hacluster|
|node2.example.com|192.168.0.103|hacluster|


_Host entry_
```bash
# sudo vi /etc/hosts
192.168.0.102  node1.example.com
192.168.0.103  node2.example.com
192.168.0.150  floating ip
```

**Server1**

Install the Cluster On both server

```bash
sudo yum install corosync pacemaker pcs -y
```
enable and start the service

```bash
sudo systemctl enable pcsd
sudo systemctl start pcsd
sudo systemctl status pcsd
```

create the cluster user password

```bash
sudo passwd hacluster
```
Allow authentication for pcs

```bash
sudo pcs cluster auth node1.example.com node2.example.com -u hacluster -p . --force
```

create a cluster

```bash
sudo pcs cluster setup --name examplecluster node1.example.com node2.example.com
```

enable & start the cluster

```bash

sudo pcs cluster enable --all
sudo pcs cluster start --all
```

to check status

```bash
sudo pcs status
```
**Configuring Cluster Options**

**Disable STONITH**

1.what is STONITH

* STONITH (Shoot The Other Node In The Head) is a Linux service for maintaining the integrity of nodes in a high-availability (HA) cluster.

* STONITH automatically powers down a node that is not working correctly. An administrator might employ STONITH if one of the nodes in a cluster can not be reached by the other node(s) in the cluster.

```bash
sudo pcs property set stonith-enabled=false
```
**ignore the Quorum policy**

1.what is Quorum policy

* A quorum policy is composed of one or more quorum policy rules. A quorum policy rule is composed of: Quorum Group: A set of members in the group that are needed to approve an operation. Administrator: Minimum number of administrators that need to approve the operation.

 
```bash
sudo pcs property set no-quorum-policy=ignore
```

To check the property list

```bash
sudo pcs property list
```
**Adding a Cluster Service**

1.Add floating IP

```bash
sudo pcs resource create floating_ip ocf:heartbeat:IPaddr2 ip=192.168.10.20 cidr_netmask=24 op monitor interval=60s
```
2.Add http_server

```bash
sudo pcs resource create http_server ocf:heartbeat:nginx configfile="/etc/nginx/nginx.conf" op monitor timeout="20s" interval="60s"
```
_check the status_
```bash
sudo pcs status resources
````

If you use firewadd add the service

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=high-availability	
sudo firewall-cmd --reload
```

then check ur Floating ip to your browser `192.168.0.150`



## error

 Error: Unable to synchronize and save tokens on nodes: hadoop02, hadoop01. Are they authorized?
 
 cd  /etc/corosync
 rm corosync.conf
