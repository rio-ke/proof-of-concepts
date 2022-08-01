## user-delete-from-user-input.md

```bash
#!/usr/bin/env bash

USERNAME="jino, dodo"
for NAME in $USERNAME; do
    USER=$(cat /etc/passwd | grep ${NAME} | awk -F: '{print $1}')
    if [ "${USER}" == "${NAME}" ]; then
        echo "${USER} is available in the system"
        echo "${NAME} is going to be delete"
        # sudo userdel -r "${NAME}"
    else
        echo "${NAME} is not available in the system"
    fi
    echo ""
done
```
