#!/usr/bin/env bash

set -x

read -p "Enter the backup file name : " FILE
read -p "Enter the databse name : " DATABASE
read -p "Enter the user-name : " USER
read -p "Enter the password : " PASS

echo "$FILE"
#DBSERVER=myserver.com
echo "$DATABASE"
echo "$USER"
echo "$PASS"

#remove the previous version of the file if it's already copied
unalias rm 2>/dev/null
rm ${FILE} 2>/dev/null
rm ${FILE}.gz 2>/dev/null

#mysql database backup (dump)

# use this command for a database server on a separate host:
#mysqldump --opt --protocol=TCP --user=${USER} --password=${PASS} --host=${DBSERVER} ${DATABASE} > ${FILE}

# use this command for a database server on localhost. add other options if need be.
sudo mysqldump --user=${USER} --password=${PASS} ${DATABASE} >$HOME/${FILE}

# (4) gzip the mysql database dump file
gzip $FILE

# (5) show the user the result
echo "${FILE}.gz was created:"
ls -ltrh /$HOME/${FILE}.gz

##[error] ls: cannot access '//home/rcms-lap-173/new-sql.gz': No such file or directory
#but the backup file will be in /home/user/ directry

# 0 */12   * * *   root   cd /etc/mysql/backup/ && sh backupReleaseShell.sh
