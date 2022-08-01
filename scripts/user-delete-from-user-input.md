## user-delete-from-user-input.md

```bash
#!/usr/bin/env bash
echo "ENTER YOUR USERNAME :"
read -a USERNAME
for NAME in $USERNAME; do
    USER=$(cat /etc/passwd | grep ${NAME} | awk -F: '{print $1}')
    if [ "${USER}" == "${NAME}" ]; then
        echo "${USER} is available in the system"
        echo "${NAME} is going to be delete"
        # sudo userdel -r "${NAME}"
    else
        echo "${USER} is not available in the system"
    fi
done
```
