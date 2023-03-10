# Mysql replica work in drbd-pcs cluster with four instance

**_Instances_**

| node   | hostname      | virtual-ip    |
| ------ | ------------- | ------------- |
| server | cluster-node1 | 192.168.1.155 |
| admin  | cluster-node2 | 192.168.1.166 |

**_cluster-drbd-check_**

- First check cluster node with the pcs status so pcs resource for mysql is placed

```cmd
sudo pcs status
```

_drbd-disk-sync_

```cmd
drbdadm status
```

```cmd
df -Th
```

**_replica-configuration_**

Create dircetory for bin-log

- go to cluster-node and open database mount folder

```cmd
cd /drbd-dbdata/
```

```cmd
mkdir Binlog-dir
```

_change file ownership to mysql_

```cmd
chown -R mysql:mysql /drbd-dbdata/Binlog-dir/
```

- Now give this path to my.cnf file for `log_bin =`

_first login to mysql database_

```cmd
mysql -h [virtual-ip] -u root -p [passwd]
```


**_Check log-bin status_**

_View the binary log location_

- To view the default location of the binary location, execute the following query:

```sql
SHOW VARIABLES LIKE '%log-bin%';
```

```sql
show variables like ‘log_bin’;
```

_Enabling binary logging_

- To disable the binary logging, add the following lines in the my.cnf file.

```cnf
[mysqld]

log_bin = /path/mysql-bin

# skip-log-bin to disabling the log-bin
```

_retsart the pcs cluster_

`step-1`

```cmd
sudo pcs cluster stop --all
```

`step-2`

```cmd
sudo pcs cluster start --all
```

- To view the list of the binary logs, run the below command in MySQL command line utility:

```sql
show binary logs;
```

![binlog](https://user-images.githubusercontent.com/88568938/224224289-219dae24-1ceb-43f5-aa31-61423409cc10.png)
