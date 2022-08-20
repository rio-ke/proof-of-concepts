postgresql-installation-and-configuration.md
---

|server|service|port|
|---|---|---|
|ubuntu| postgresql|5432|

* The default configuration file is located here

`/etc/postgresql/14/main/postgresql.conf`


_installation_

```bash
sudo apt-get update 
sudo apt-get install postgresql postgresql-contrib -y

```

_service management_

```bash
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl status postgresql
```

_How do I login and authenticate to Postgresql after a fresh install?_

```bash
sudo -u postgres psql postgres
```

default user password assign

```bash
ALTER USER postgres PASSWORD '.';
```

_Disable the peer connectivity and enable the md5 authentication_

file location `/etc/postgresql/14/main/pg_hba.conf`

```bash
# comment those two lnes
local   all             postgres                                peer
local   all             all                                     peer
# add those two lines
local   all             postgres                                md5
local   all             all                                     md5
```
_service reload_

```bash
sudo systemctl stop postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql
```

