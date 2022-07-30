## shell script for mysql-backup

```bash
#!/bin/bash

# set -x to debug mode

#current date
DATE=`date +%y_%m_%d`

echo "username"
read USER
echo"password"
read PASSWORD
echo"DB NAME"
read DB
echo"DB1 NAME"
read DB1
echo"DB2 NAME"
read DB2

#list of fields
mysqlogin=$( echo 'show databases' | mysql -u$0USER -p$PASSWORD )
 
#we loop on each folder (for automatically cut by the space)
for backup in $mysqlogin
 
do
 
if [ $backup != "$DB" ] && [ $backup != "DB1" ] && [ $backup != "DB2" ]; then
 
#echo $SQL
mysqldump -u$USER -p$PASSWORD $backup | gzip > /home/kendanic/backup/$backup"_mysql_"$DATE.sql.gz
 
fi
 
done

```


**_command execution_**

```bash
mysql-backup.sh
```
