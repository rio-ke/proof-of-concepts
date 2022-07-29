## shell script for mysql-backup

```bash
#!/bin/bash

# set -x to debug mode

#current date
DATE=`date +%y_%m_%d`
 
#list of fields
mysqlogin=$( echo 'show databases' | mysql -ukendanic -ppassword )
 
#we loop on each folder (for automatically cut by the space)
for backup in $mysqlogin
 
do
 
if [ $backup != "information_schema" ] && [ $backup != "mysql" ] && [ $backup != "Database" ]; then
 
#echo $SQL
mysqldump -ukendanic -ppassword $backup | gzip > /home/kendanic/backup/$backup"_mysql_"$DATE.sql.gz
 
fi
 
done

```bash


**_command execution_**

```bash
mysql-backup.sh
```
