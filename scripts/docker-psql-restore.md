
## docker-psql-restore

**script**

```bash

#!/usr/bin/env bash
# docker-psql-restore.sh

USER=postgres
DATABASE=dodo

cat psql_bak.sql | docker exec -i $DATABASE psql -U $USER

```

**execution**

```bash

bash docker-psql-restore.sh

```
