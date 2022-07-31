## Docker-mysql-backup


https://gist.github.com/spalladino/6d981f7b33f6e0afe6bb


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
