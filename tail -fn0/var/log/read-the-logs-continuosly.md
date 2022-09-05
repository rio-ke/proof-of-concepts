## read-the-logs-continuosly.md

```sh
tail -fn0 /var/log/syslog |
    while read LINE; do
        echo "${LINE}" | grep -i "useradd"
        if [ $? = 0 ]; then
            # ... do something ...
            echo "Found the pattern"
        fi
    done
```
