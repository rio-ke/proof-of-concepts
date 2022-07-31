## Docker-mysql-backup



**script**
```bash

#!/usr/bin/env bash
# docker-mysql-backup.sh

CONTAINER=mysql
USER=root
PASSWORD=MyNewPass
DATABASE=dodo


docker exec $CONTAINER /usr/bin/mysqldump -u $USER --password=$PASSWORD $DATABASE > backup.sql

```

**execution**
```bash

bash docker-mysql-backup.sh

```
