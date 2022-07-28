

```bash
#!/usr/bin/env bash
# mysql-db-creation.md

USERNAME="root"
PASSWORD="xxx"
mysql -u${USERNAME} -p${PASSWORD} -e "create database 'foo'"
```

_execution_

```bash
bash mysql-db-creation.md
```
