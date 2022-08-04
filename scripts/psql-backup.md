## install psql-backup-script



**_script_**
```bash
#!/usr/bin/env bash
#psql-backup.sh

USER=root
PASSWORD=MyNewPass
DATABASE=apps

pg_dump -U$USER -p$PASSWORD $DATABASE > tecmintdb.sql 
```

**_execution_**

```bash
bash psql-backup.sh
```
