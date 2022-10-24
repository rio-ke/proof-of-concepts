**server configuration**

| name  | ip address    |
| ----- | ------------- |
| node1 | 172.31.41.94  |
| node2 | 172.31.38.157 |

**node1 and node2 make an /etc/hosts entry**

```bash
cat <<EOF >> /etc/hosts
172.31.38.157 node2
172.31.41.94 node1
EOF
hostnamectl set-hostname node2
hostnamectl set-hostname node1
```

**preparation of the pcs clusters on node1 and node2**

```bash
yum update -y
# install packages like httpd, drbd, pcs
yum install pacemaker drbd pcs psmisc policycoreutils-python httpd
# disble the selinux
setenforce
# disable the firewalld
systemctl stop firewalld
systemctl disable firewalld
# Enable the server status for httpd server
cat <<EOF >> /etc/httpd/conf.d/status.conf
<Location /server-status>
    SetHandler server-status
    Require local
</Location>
EOF
```

**prepare the drbd configuration both node1 and node2**

```bash
cat <<EOF >>  /etc/drbd.d/clusterdb.res
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
    disk /dev/xvdb;
    address 172.31.41.94:7788;
    flexible-meta-disk internal;
  }
 on node2 {
    device /dev/drbd0;
    disk /dev/xvdb;
    address 172.31.38.157:7788;
    meta-disk internal;
  }
}
EOF
```

**prepare the drbd setup both node1 and node2**

```bash
drbdadm create-md clusterdb
drbdadm up clusterdb
systemctl start drbd
systemctl enable drbd
systemctl status drbd
```

**initiate the cluster on node1**

```bash
drbdadm -- --overwrite-data-of-peer primary clusterdb
```

**check the drbd sync status both node1 and node2**

```bash
 cat /proc/drbd
```

**create the folder both node1 and node2**

```bash
mkdir /drbd-webdata
mkdir /drbd-mysql
```

**lvm configuration change both node1 and node2**

```bash
vim /etc/lvm/lvm.conf
add:  filter = [ "r|/dev/vdb1|", "r|/dev/disk/*|", "r|/dev/block/*|", "a|.*|" ]     # near 128 line
edit: write_cache_state = 1 to write_cache_state = 0                                # near 128 line
edit: use_lvmetad = 1 to  use_lvmetad = 0                                           # 958 line near by
```

**update the lvm configuration on node1 and node2**

```bash
lvmconf --enable-halvm --services --startstopservices
dracut -H -f /boot/initramfs-$(uname -r).img $(uname -r)
reboot
```

**reconnect both node1 and node2**

```bash
cat /proc/drbd
systemctl start pcsd.service
systemctl enable pcsd.service
passwd hacluster
```

**any one of server you can mark as a primary**

```bash
# assume node1
drbdadm primary --force clusterdb
```