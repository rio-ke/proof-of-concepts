**Postgres Installation**

Before Postgres installation we need to confirm postgres service exist or not. Suppose is it is not exist we have to run the below command
```bash
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql.service

sudo systemctl start postgresql.service
sudo systemctl status postgresql.service
```
Create the postgres user for postgres exporter
```
sudo -u postgres psql
CREATE USER postgres_exporter ENCRYPTED PASSWORD 'Password@123';
GRANT pg_read_all_data TO postgres_exporter;
GRANT pg_write_all_data TO postgres_exporter;
CREATE DATABASE demo;
GRANT ALL PRIVILEGES ON DATABASE demo TO postgres_exporter;
```

Create the user and folders to handle the postgres exporter process itself. So we are aware of user-based processes and permissions. 
```
sudo useradd --no-create-home -c "Monitoring user" --shell /bin/false postgres_exporter
```
Download the binary
```
wget https://github.com/wrouesnel/postgres_exporter/releases/download/v0.5.1/postgres_exporter_v0.5.1_linux-amd64.tar.gz
tar -xzvf postgres_exporter_v0.5.1_linux-amd64.tar.gz
sudo mv postgres_exporter_v0.5.1_linux-amd64/postgres_exporter /usr/local/bin

```
Permission setup
```
chown -R postgres_exporter:postgres_exporter /usr/local/bin/postgres_exporter
```
Prepare the env File
```
mkdir /opt/postgres_exporter
cd /opt/postgres_exporter
```
```bash
# sudo vim postgres_exporter.env
DATA_SOURCE_NAME="postgresql://username:password@localhost:5432/database-name?sslmode=disable"
```
Add the below content for promotheus psql server
```bash
[Unit]
Description=Prometheus exporter for Postgresql
Wants=network-online.target
After=network-online.target

[Service]
User=postgres_exporter
Group=postgres_exporter
Restart=always
WorkingDirectory=/opt/postgres_exporter
EnvironmentFile=/opt/postgres_exporter/postgres_exporter.env
ExecStart=/usr/local/bin/postgres_exporter --web.listen-address=:9187 --web.telemetry-path=/metrics

[Install]
WantedBy=multi-user.target
```
Finally, enable and start the service
```
sudo systemctl daemon-reload
sudo systemctl start postgres_exporter
sudo systemctl enable postgres_exporter
sudo systemctl status postgres_exporter
```
**Integrate the Postgres exporter to Prometheus**

First, you need to edit `/etc/prometheus/prometheus.yml` configuration file. Then, add the new targets to scrape

```
---
global:
  scrape_interval:     15s      # default 1m
  evaluation_interval: 15s      # default 1m
  scrape_timeout: 10s           # default 10s
  
- job_name: ‘postgres_exporter’
  static_configs:
  - targets: [‘172.31.20.235:9187’]   # Our machine IP Address
    labels:
      instance: db-server
```
Finally, reload the service
```
sudo systemctl start prometheus
sudo systemctl status prometheus
```




























