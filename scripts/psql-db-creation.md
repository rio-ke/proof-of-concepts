#### psql db creation-script

```bash

##!/usr/bin/env bash
# psql-db-creation.sh

USERNAME="postgres"
PASSWORD="Password@123"
sudo createdb -p$PASSWORD -U $USERNAME testdb;
sudo -u postgres psql -c "\l"

```
_execution_

```bash
bash psql-db-creation.sh
```
