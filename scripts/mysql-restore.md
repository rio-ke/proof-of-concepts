## install mysql_restore-script

**_script_**
```bash

#!/usr/bin/env bash
# mysql_restore_install.sh

USER=root
PASSWORD=MyNewPass
DATABASE=apps

mysql -u$USER -p$PASSWORD $DATABASE < /home/dodo/mysql.sql

```

**_execution_**

```bash
bash mysql_restore_install.sh
```
 
