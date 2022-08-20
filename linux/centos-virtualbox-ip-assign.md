## centos-virtualbox-ip-assign 


Install a new install of CentOS in a virtual machine if the IP address is not assigned via wifi or a mobile network in such scenario.

Follow the instruction.


```bash

vim /etc/sysconfig/network-scripts/ifcfg-enp

```
`change ONBOOT=no to ONBOOT=yes`


```bash
#vim /etc/resolve.conf

# Add the file google nameservers 
nameserver 8.8.8.8 
nameserver 8.8.4.4

```

then restart the device
