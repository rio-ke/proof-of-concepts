## mysql replication slave configuration

**DB1**

```bash
Master server: 192.168.xx.xxx
Slave server: 192.168.xx.xxx
```

**_Install MySQL on Master Nodes_**

```bash
sudo apt update && sudo apt install mysql-server
```

**_Open the mysql configuration file on the Master node._**

`Edit`

```bash
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```

```bash
bind-address = master-server-ip
server-id = 1
##
log_bin = /var/log/mysql/mysql-bin.log
log_bin_index =/var/log/mysql/mysql-bin.log.index
relay_log = /var/log/mysql/mysql-relay-bin
relay_log_index = /var/log/mysql/mysql-relay-bin.index
```

**_save the configuration file and restart MySQL service for the changes to take effect on Master node_**

```bash
sudo systemctl restart mysql && sudo systemctl status mysql
```

**_Create a New User for Replication on Master Node_**

_log in to the MySQL master-server as shown_.

```bash
sudo mysql -u root -p
```

pass: xxxxxxx

_Next, proceed and execute the queries below to create a replica user and grant access to the replication slave. Remember to use your IP address._

```bash
CREATE USER 'demo'@'192.168.xxx.xx' IDENTIFIED BY 'Demo@12pass';  #(add slave ip_address here in remote-users)
```

```bash
GRANT REPLICATION SLAVE ON *.* TO 'demo'@'192.168.137.69';  #(add slave ip_address here in remote-users)
```

```bash
FLUSH PRIVILEGES;
```

```bash
SHOW MASTER STATUS;
```

Note the `mysql-bin.000001` value and the Position ID `xxxx`. These values will be crucial when setting up the slave server.

**DB2**

**_Install MySQL on Slave Nodes_**

```bash
sudo apt update && sudo apt install mysql-server
```

**_Open the mysql configuration file on the Slave node._**

`Edit`

```bash
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```

```bash
bind-address = slave-server-ip
server-id = 2
##
log_bin = /var/log/mysql/mysql-bin.log
log_bin_index =/var/log/mysql/mysql-bin.log.index
relay_log = /var/log/mysql/mysql-relay-bin
relay_log_index = /var/log/mysql/mysql-relay-bin.index
```

**_save the configuration file and restart MySQL service for the changes to take effect on Slave node_**

```bash
sudo systemctl restart mysql && sudo systemctl status mysql
```

_log in to the MySQL server as shown_.

```bash
sudo mysql -u root -p
```

pass: xxxxxxx

**_stop mysql-replication in slave server_**

```bash
STOP SLAVE;
```

**_ADD the cmd lines in Slave node one by one _**

```bash
mysql> CHANGE MASTER TO MASTER_HOST='192.168.137.153', #(master_ip)
mysql> MASTER_USER='demo',
mysql> MASTER_PASSWORD='Demo@12pass',
mysql> MASTER_LOG_FILE='mysql-bin.000001', #(master node)
mysql> MASTER_LOG_POS=1114,
mysql> SOURCE_SSL=1;
```

**_start the slave replication slave server_**

```bash
START SLAVE;
```

**_show master-slave replica status in slave server_**

```bash
SHOW REPLICA STATUS\G;
```

```bash

*************************** 1. row ***************************
             Replica_IO_State: Waiting for source to send event
                    Source_Host: 192.168.137.153
                   Source_User: demo
                    Source_Port: 3306
                Connect_Retry: 60
             Source_Log_File: mysql-bin.000001
  Read_Source_Log_Pos: 1114
               Relay_Log_File: mysql-relay-bin.000002
               Relay_Log_Pos: 326
       lay_Source_Log_File: mysql-bin.000001
            plica_IO_Running: Yes
         plica_SQL_Running: Yes

```

**Testing the configuration in both master-slave servers**

**_IN Master-server_**

Create Database in master-server

```bash
CREATE DATABASE kendanic;
```

```bash
show databases;
```

**_IN slave-server_**

```bash
sudo mysql
```

check if database created in master-server appers in slave-server

```bash
show databases;
```
