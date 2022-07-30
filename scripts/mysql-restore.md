#!/usr/bin/env bash
# mysql-restore-creation.sh

USER=root
PASSWORD=MyNewPass
DATABASE=apps

mysql -u$USER -p$PASSWORD $DATABASE < /home/dodo/mysql.sql
 
