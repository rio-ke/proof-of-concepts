# mysql replica conf-tuning for master and slave

**_Master node_**


```cnf
# BINARY LOGGING #

server_id                      = 1 
log_bin                        = /drbd-dbdata/Binlog-file/mysql-bin 
log_bin_index                  = /drbd-dbdata/Binlog-file/mysql-bin 
binlog_do_db                   = replicadb1
binlog_do_db                   = replicadb2
max_binlog_size                = 500M
expire_logs_days               = 2 
sync_binlog                    = 1
#binlog_format                 = row
user                           = mysql
symbolic-links                 = 0
#slow_query_log                =
#gtid-mode                     = on 
#enforce-gtid-consistency      = true 
master-info-repository         = TABLE 
relay-log-info-repository      = TABLE 
slave-parallel-workers         = 2 
#binlog-checksum               = CRC32 
master-verify-checksum         = 1 
slave-sql-verify-checksum      = 1 
binlog-rows-query-log_events   = 1 
log_slave_updates              = 1
```

**_Slave node_**

```cnf
# BINARY LOGGING # 
server_id                      = 2 
log_bin                        = /drbd-dbdata/Binloglog-file/mysql-bin  
log_bin_index                  = /drbd-dbdata/Binlog-file/mysql-bin
binlog_do_db                   = replicadb1
binlog_do_db                   = replicadb2
expire_logs_days               = 2 
sync_binlog                    = 1 
binlog_format                  = row 
relay_log                      = /drbd-dbdata/relayloglog-file/mysql-relay-bin 
log_slave_updates              = 1 
read_only                      = 1
slave-skip-errors 		         = 1032,1062
#gtid-mode                     = on 
#enforce-gtid-consistency      = true 
master-info-repository         = TABLE 
relay-log-info-repository      = TABLE 
#slave-parallel-workers        = 2 
#binlog-checksum               = CRC32 
master-verify-checksum         = 1 
slave-sql-verify-checksum      = 1 
binlog-rows-query-log_events   = 1
log-slave-updates              = 1
#binlog_format                 = mixed
```
