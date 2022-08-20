**_User Management_**

---

**_what is user management?_**

User Administration is the process of managing different user accounts and their respective permissions in an operating system.In Linux or Unix-based 
operating systems, we can create different user accounts, sort them into groups, change their set of permissions or delete them. The terminal commands 
for each of the above-stated actions are discussed below.

**Requirements**

|operating system | username | groupname |
|---|---|---|
|Ubuntu| dodo | lucas |

_**Group Creation Details**_

```bash
# Create group 
sudo groupadd lucas
```

```bash
# One group into one user
sudo usermod -a -G lucas dodo 
```

```bash
# Muliple group in one user
usermod -a -G lucas1,lucas2,lucas3 dodo
```

```bash
# Remove a user from group
sudo gpasswd -d  dodo lucas
```

```bash
# User information
sudo usermod -c "This is dodo user" dodo
```

```bash
# Add the users into docker group
sudo usermod -aG docker ubuntu4
```

```bash
# List out the created group
cat /etc/group
```

```bash
# set a password in group user
sudo gpasswd groupname
```
```bash
#  Remove user from a user group
 sudo deluser dodo lucas
```
_**User Creation Details:**_

```bash
# create the user
sudo useradd dodo
```
```bash
# Login to the user
su dodo
   (or)
ssh dodo@ip_address
   (or)
ssh dodo@localhost
```
```bash
# Delete the user
sudo userdel dodo
```
```bash
# set a password in user
sudo passwd dodo
```
```bash
# List out the created users
cat /etc/passwd
```
```bash
#  Disable a user
sudo passwd -l dodo
```
```bash
 # Gives information on all logged in user
 finger
 ```
 ```bash
 # Gives information of a particular user
finger dodo
```
#### Give the Permission - File to Group

```bash
# Create a file 
touch filename
```
```bash
# Ggive the permission - group to file
chgrp groupname filename
```
```bash
# To give the read, write, execute permission
chmod g+rwx filename
```
```bash
# view the file content in the user
cat filename
```
#### Output 
![image](https://user-images.githubusercontent.com/91359308/166628994-2dc3f3f6-87f2-4c7a-a8e0-cc3f557c8a92.png)
![image](https://user-images.githubusercontent.com/91359308/166631218-3d6ef51f-5fc9-447e-bf2c-d9d09dd5ec10.png)


_user permission management_

|users|
|---|
|usera|
|userb|


create a user 

```bash

sudo adduser usera
sudo adduser userb

```

While creating a user, it should automatically create a group in the username's name.
 
