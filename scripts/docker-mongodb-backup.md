## docker-mongodb-backup

**script**
```bash

#!/usr/bin/env bash
# docker-mongodb-backup.sh

CONTAINER=mongodb
USER=root
PASSWORD=MyNewPass
DATABASE=dodo

docker exec -i $CONTAINER /usr/bin/mongodump --username $USER --password $PASSWORD --authenticationDatabase admin --db $DATABASE --out /dump
docker cp $CONTAINER:/dump ~/Downloads/dump
```

**execution**
```bash

bash docker-mongodb-backup.sh

```
