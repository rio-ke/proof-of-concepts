## user management
User management includes everything from creating a user to deleting a user on your system.

_**Requirmenets**_

|users | state |
|---|---|
| root | default user |
| dodo | custom user |

_**root user**_

The root user is the `superuse`r and have all the permissions for creating a user, deleting a user and can even login with the other user's account. The root user always has userid 0. this user can be control entire systes.

_**custom user creation process**_

_**in ubuntu**_

```bash
useradd dodo
```
In this command create /etc/passwd, /etc/shadow, /etc/group and /etc/gshadow files for the newly created user accounts.

**User without Home Directory**
```bash
useradd -M username
```

**useradd with account Expiry**

```bash
useradd -e 2021-08-27 username
```
**Set passwd expiry to user account**
```bash
chage -M 120 username
```
to set expiry date to the user

aand check **man chage** for more details

_**user deletion**_

with userdel command you can dlelete a user

```bash
sudo userdel -f dodo
```
**Set Password**

```bash
sudo passwd dodo
```
**To check user creation**

```bash
cat /etc/passwd
```
**Group Creation **

```bash 
groupadd Group-Name
```
The command adds an entry for the new group to the /etc/group and /etc/gshadow files.

```bash
groupadd -f mygroup
```

**Group add with specify Group ID**

```bash
groupadd -g 1010 mygroup
```
to view and **verify the GroupID** use this command

```bash
getent group | grep mygroup
```
**group Create with Password use this command**

```bash
groupadd -p grouppassword mygroup
```
---

In this command udsed to delete the group

```bash
groupdel GROUPNAME
```
to verify the group delete

```bash
getent group | grep groupname
```
In this command used to add the existing group

```bash
sudo usermod -a -G groupname username
```
in this command user to **ange the primary group for the user**
```bash
sudo usermod -g groupname username
```

In this command used to **mve the user from the group**
```bash
sudo gpasswd -d username groupname
```

in this command used to **user linked groups**
```bash
groups username
```

_**custom shell assign for users**_

_**in centos**_

Change User Shell in /etc/passwd File **UbuntuOS**

```bash
vi /etc/passwd
```


---
For more user commands Please Refer -- https://www.tecmint.com/add-users-in-linux/
