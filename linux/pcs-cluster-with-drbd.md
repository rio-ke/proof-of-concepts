# BOTH NODE:

     DISK: /dev/cdb -> n-p-1-enter-enter-p-w-partprobe---> after Disk vdb1 created.check it lsblk

node 1 and node2

```bash
     yum update -y
     yum install -y pacemaker pcs psmisc policycoreutils-python
     rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
     rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
     yum install -y kmod-drbd84 drbd84-utils
     yum install httpd mariadb mariadb-server php
```

node 1 and node2

```bash
# vim /etc/httpd/conf.d/status.conf
<Location /server-status>
    SetHandler server-status
    Require local
</Location>
```

node 1 and node2

```bash
    setenforce 0
    systemctl stop firewalld
    systemctl disable firewalld
    #  firewall-cmd --permanent  --add-rich-rule='rule family=ipv4 source address=192.168.122.0/24 accept'
    #  firewall-cmd --reload
    modprobe drbd
```

node 1 and node2

```bash
# vim /etc/drbd.d/clusterdb.res
resource clusterdb {
protocol C;
  handlers {
    pri-on-incon-degr "/usr/lib/drbd/notify-pri-on-incon-degr.sh; /usr/lib/drbd/notifyemergency-reboot.sh; echo b > /proc/sysrq-trigger ; reboot -f";
    pri-lost-after-sb "/usr/lib/drbd/notify-pri-lost-after-sb.sh; /usr/lib/drbd/notifyemergency-reboot.sh; echo b > /proc/sysrq-trigger; reboot -f";
    local-io-error "/usr/lib/drbd/notify-io-error.sh; /usr/lib/drbd/notify-emergencyshutdown.sh; echo o > /proc/sysrq-trigger ; halt -f";
    fence-peer "/usr/lib/drbd/crm-fence-peer.sh";
    split-brain "/usr/lib/drbd/notify-split-brain.sh admin@acme.com";
    out-of-sync "/usr/lib/drbd/notify-out-of-sync.sh admin@acme.com";
  }
    startup {
      degr-wfc-timeout 120; # 2 minutes.
      outdated-wfc-timeout 2; # 2 seconds.
    }
    disk {
      on-io-error detach;
    }
    net {
      cram-hmac-alg "sha1";
      shared-secret "clusterdb";
      after-sb-0pri disconnect;
      after-sb-1pri disconnect;
      after-sb-2pri disconnect;
      rr-conflict disconnect;
    }
        syncer {
      rate 150M;
      al-extents 257; #Also Linbit told me so personally. The recommended range for this should be between 7 and 3833. The default value is 127
      on-no-data-accessible io-error;
    }
  on node1 {
    device /dev/drbd0;
    disk /dev/vdb1;
    address 192.168.122.109:7788;
    flexible-meta-disk internal;
  }
  on node2 {
    device /dev/drbd0;
    disk /dev/vdb1;
    address 192.168.122.45:7788;
    meta-disk internal;
  }
}
```

node1

```bash
     drbdadm create-md clusterdb
     drbdadm up clusterdb
     systemctl start drbd
     systemctl enable drbd
     drbdadm -- --overwrite-data-of-peer primary clusterdb
```

node2

```bash
     drbdadm create-md clusterdb
     drbdadm up clusterdb
     systemctl start drbd
     systemctl enable drbd
```

vim /etc/lvm/lvm.conf

add: filter = [ "r|/dev/vdb1|", "r|/dev/disk/*|", "r|/dev/block/*|", "a|.*|" ]
edit: write_cache_state = 1 to write_cache_state = 0
edit: use_lvmetad = 1 to use_lvmetad = 0

lvmconf --enable-halvm --services --startstopservices
dracut -H -f /boot/initramfs-$(uname -r).img $(uname -r)
reboot

#cat /proc/drbd

node1# drbdadm primary --force clusterdb

     systemctl start pcsd.service
     systemctl enable pcsd.service
     passwd hacluster

# NODE ONE:

pvcreate /dev/drbd0
vgcreate drbd-vg /dev/drbd0
lvcreate --name drbd-jj --size 2G drbd-vg
lvcreate --name drbd-jjj --size 2G drbd-vg
(optional): vgchange -ay drbd-vg (active Volume group)

(optional): vgchange -an drbd-vg (Deactive Volume group)

     pcs cluster auth node1 node2 -u hacluster -p .
     pcs cluster setup --name mycluster node1 node2
     pcs cluster start --all
     pcs cluster enable --all
     pcs property set stonith-enabled=false
     pcs property set no-quorum-policy=ignore


     pcs cluster cib drbd_cfg
     pcs -f drbd_cfg resource create drbd_clusterdb ocf:linbit:drbd drbd_resource=clusterdb
     pcs -f drbd_cfg resource master drbd_clusterdb_clone drbd_clusterdb master-max=1 master-node-max=1 clone-max=2 clone-node-max=1 notify=true
     pcs cluster cib-push drbd_cfg
     pcs resource create lvm ocf:heartbeat:LVM volgrpname=drbd-vg
     pcs resource create webfsone Filesystem device="/dev/drbd-vg/drbd-jj" directory="/jino1" fstype="xfs"
     pcs resource create webfstwo Filesystem device="/dev/drbd-vg/drbd-jjj" directory="/jino2" fstype="xfs"
     pcs resource create virtualip ocf:heartbeat:IPaddr2 ip=192.168.122.100 cidr_netmask=24 nic=etho
     pcs resource create webserver ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf statusurl="http://localhost/server-status"
     pcs resource group add jinogroup virtualip lvm webfsone webfstwo  webserver
     pcs constraint order promote drbd_clusterdb_clone then start jinogroup INFINITY
     pcs constraint colocation add jinogroup  with master drbd_clusterdb_clone INFINITY
     pcs resource create ftpserver systemd:vsftpd --group jinogroup

     #mv /etc/my.cnf /jino2/my.cnf
     #mkdir -p /jino2/data
     #vim /jino2/my.cnf
     datadir=/jino2/data
     bind-address=192.168.122.100

(or)
bind-address=0.0.0.0
mysql*install_db --no-defaults --datadir=/jino2/data
chown -R mysql:mysql /jino2/
pcs resource create dbserver ocf:heartbeat:mysql config="/jino2/my.cnf" datadir="/jino2/data" pid="/var/lib/mysql/mysql.pid" socket="/var/lib/mysql/mysql.sock" user="mysql" group="mysql" additional_parameters="--user=mysql" --group jinogroup
mysql –h 192.168.0.4 –u root –p
GRANT ALL ON *.\_ TO 'root'@'%' IDENTIFIED BY 'MyDBpassword';
FLUSH PRIVILEGES;
CREATE DATABASE cluster_db;

pcs resource defaults resource-stickiness=100
pcs resource op defaults timeout=240s
pcs stonith describe fence_ipmilan
pcs cluster cib stonith_cfg
pcs -f stonith_cfg stonith create ipmi-fencing fence_ipmilan pcmk_host_list="node1 node2" ipaddr=10.0.0.1 login=testuser passwd=acd123
pcs -f stonith_cfg property set stonith-enabled=true
pcs -f stonith_cfg property
pcs cluster cib-push stonith_cfg --config

pcs cluster stop node2
stonith_admin --reboot node2

     refer:
     http://isardvdi-the-docs-repo.readthedocs.io/en/latest/setups/ha/active_passive/
     http://blog.zorangagic.com/2016/02/drbd.html
     http://avid.force.com/pkb/articles/en_US/Compatibility/Troubleshooting-DRBD-on-MediaCentral#A
     http://sheepguardingllama.com/2011/06/drbd-error-device-is-held-open-by-someone/

===================================================================================================================================
If you get degraded DRBD with log messages like “Split-Brain detected but unresolved, dropping connection!”, you have to manually resolve split brain situation.

Possible reason for such situation

    You switch all cluster nodes in standby via cluster suite (i.e. pacemaker) at the same time, so you don’t have any active drbd instance running.
    You switch the node, which was in Secondary status in drbd last time, online.
    You switch other nodes online

Result:

#/proc/drbd on the node1
version: 8.4.0 (api:1/proto:86-100)
GIT-hash: 28753f559ab51b549d16bcf487fe625d5919c49c build by gardner@, 2011-12-1
2 23:52:00
0: cs:StandAlone ro:Secondary/Unknown ds:UpToDate/DUnknown r-----
ns:0 nr:0 dw:0 dr:0 al:0 bm:0 lo:0 pe:0 ua:0 ap:0 ep:1 wo:b oos:76

#log message on the node1
Mar 7 15:38:05 node1 kernel: block drbd0: Split-Brain detected but unresolved, dropping connection!

#/proc/drbd on the node2
version: 8.4.0 (api:1/proto:86-100)
GIT-hash: 28753f559ab51b549d16bcf487fe625d5919c49c build by gardner@, 2011-12-1
2 23:52:00
0: cs:StandAlone ro:Primary/Unknown ds:UpToDate/DUnknown r-----
ns:0 nr:0 dw:144 dr:4205 al:5 bm:0 lo:0 pe:0 ua:0 ap:0 ep:1 wo:b oos:100

Manually resolve this split brain situation

Start drbd manually on both nodes

Define one node as secondary and discard data on this

drbdadm secondary all
drbdadm disconnect all
drbdadm -- --discard-my-data connect all

Think about the right node to discard the data, otherwise you can lose some data

Define another node as primary and connect

drbdadm primary all
drbdadm disconnect all
drbdadm connect all

Configure drbd for auto split brain resolving

Place this configuration in drbd.conf on both nodes

net {
after-sb-0pri discard-zero-changes;
after-sb-1pri discard-secondary;
after-sb-2pri disconnect;
}
===================================================================
https://zeldor.biz/2011/07/drbd-masterslave-setup/
https://www.zenoss.com/sites/default/files/zenoss-doc/7801/book/install/ha/maps/config-master.html

# cat <<-END >/jino1/crm_logger.sh

#!/bin/sh
logger -t "ClusterMon-External" "${CRM_notify_node} ${CRM_notify_rsc} \
${CRM_notify_task} ${CRM_notify_desc} ${CRM_notify_rc} \
${CRM_notify_target_rc} ${CRM_notify_status} ${CRM_notify_recipient}";
exit;
END

chmod 755 /jino1/crm_logger.sh

pcs resource create ClusterMon-External ClusterMon user=apache update=10 extra_options="-E /usr/local/bin/crm_logger.sh
