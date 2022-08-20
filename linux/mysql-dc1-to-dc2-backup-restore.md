**DC1 to DC2 MySQL backup and restore**

----

**Requirements**

It is required two servers. this servers should be  install `mysql` service and `ssh` services.

|server name| username | IPAddress | password |
|---|---| --- | --- | 
|dc1-node1|ubuntu|192.168.0.2|PasswordChnaged|
|dc2-node1|ubuntu|192.168.1.2|PasswordChnaged|


**DC1 Server configuration**

first connect to your dc1 mysql server Create one database, then use it to create three tables.
 
 ```bash 
 
 mysql -u root -p 
 ```
 Then enter your root password,da
 
 ```bash
 
 create database data;
 ```
Now use the data database

use data;



Now create  three tables   data_1, data_2, data_3;

Insert some values in your tables;

then back up the your database

```bash

mysqldump -u root -p  database_name > backup filename or path

```

Finally transfer the backup file in your dc2 server

```bash

scp sourcefilename dc2servername@dc2 ip:/dc2 storage path
```

Now login via ssh to dc2 Server

`ssh -l dc2username ip address` 

Now login your mysql root user(Dc1)

```bash
mysql -u root -p 
```
enter the root user password

Then create new database 

```bash
CREATE DATABASE  database_name;
```
Now restore the backup.sql file

```bash
mysql -u root -p  database_name < backup.sql
```
Now check the database 
```bash
show databases;
```
```bash
use databases;
```
```bash
show tables;
```
check the count in your restore tables

```bash

SELECT COUNT(*) FROM  table_name;
```










 
 
