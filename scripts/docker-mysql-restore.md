## docker-mysql-restore

**script**

```bash
#!/usr/bin/env bash
# docker-mysql-backup.sh

CONTAINER=mysql
USER=root
PASSWORD=MyNewPass
DATABASE=dodo

cat backup.sql | docker exec -i $CONTAINER /usr/bin/mysql -u $USER --password=$PASSWORD $DATABASE
```

**execution**

```bash
bash docker-mysql-restore.sh
```
