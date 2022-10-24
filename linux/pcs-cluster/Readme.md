server configuration

| name  | ip address    |
| ----- | ------------- |
| node1 | 172.31.41.94  |
| node2 | 172.31.38.157 |

__node1 and node2 /etc/hosts entry__ 

```bash
cat <<EOF >> /etc/hosts
172.31.38.157 node2
172.31.41.94 node1
EOF
hostnamectl set-hostname node2
hostnamectl set-hostname node1
```

__node1 and node2 preparation of the pcs clusters__

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
