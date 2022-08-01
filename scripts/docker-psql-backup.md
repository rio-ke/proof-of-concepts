## docker-psql-backup

**script**

```bash

#!/usr/bin/env bash
# docker-psql-backup.sh


USER=postgres
DATABASE=dodo

docker exec -t $DATABASE pg_dumpall -c -U $USER | gzip > /home/dodo/postgres/backups

```

**execution**

```bash

bash docker-psql-backup.sh

```
