## user-delete-from-user-input.md

```bash
#!/usr/bin/env bash
echo "ENTER YOUR USERNAME :"
read -a USERNAME
for NAME in $USERNAME; do
    echo "${NAME} is going to be delete"
    # userdel -r $USERNAME
done

```
