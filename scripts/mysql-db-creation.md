

```bash
##!/usr/bin/env bash
# mysql-db-creation.sh

USERNAME="root"
PASSWORD="Password@123"
mysql -u${USERNAME} -p${PASSWORD} -e "create database test";
mysql -u${USERNAME}  -p${PASSWORD} -e "show databases"
```

_execution_

```bash
bash mysql-db-creation.sh
```
