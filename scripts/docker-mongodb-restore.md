## docker-mongodb-restore

**script**

```bash

#!/usr/bin/env bash
# docker-mongodb-restore.sh

CONTAINER=mongodb
USER=root
PASSWORD=MyNewPass
DATABASE=dodo

docker cp ~/Downloads/dump $CONTAINER:/dump
docker exec -i $CONTAINER /usr/bin/mongorestore --username $USER --password $PASSWORD --authenticationDatabase admin --db $DATABASE /dump/<database_name>
```

**execution**

```bash

bash docker-mongodb-restore.sh

```
