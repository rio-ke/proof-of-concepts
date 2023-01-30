**Postgres Installation**

Before Postgres installation we need to confirm postgres service exist or not. Suppose is it is not exist we have to run the below command
```bash
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql.service

sudo systemctl start postgresql.service
sudo systemctl status postgresql.service
```

create the postgres user for postgres exporter
```
sudo -u postgres psql
CREATE USER postgres_exporter ENCRYPTED PASSWORD 'Password@123';
GRANT pg_read_all_data TO postgres_exporter;
GRANT pg_write_all_data TO postgres_exporter;
CREATE DATABASE demo;
GRANT ALL PRIVILEGES ON DATABASE demo TO postgres_exporter;
```

Create the User and folders 

