_Disk Alerts_

```bash
#!/usr/bin/env bash

# Set alert level 80% is default
ALERT=80

# Log file storage location
LOG_FILE=/tmp/space.txt

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 " " $6 }' | while read output;
do
  usep=$(echo $output | awk '{ print $1 $3}' | cut -d'%' -f1  )
  path=$(echo $output | awk '{ print $3}' )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge $ALERT ]; then
    echo "Running out of space alerts => Disk = $partition Usgae = ($usep%) Mount - $path on $(hostname) as on $(date)" >> $LOG_FILE
  fi
done 
```


_Execution_

```bash
# create the file in the name of disk-space.sh
bash disk-space.sh
```
