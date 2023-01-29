_mysql exporter installation_

Before mysql exporter installation, make sure the MySQL service is exist. if it is not running then you should follow below steps

```bash
sudo apt install mysql-server
sudo mysql_secure_installtion
sudo systemctl start mysql
```

_create the mysql user for mysql exporter_

```bash
sudo mysql -u root -p 
CREATE USER 'mysqld_exporter'@'localhost' IDENTIFIED BY 'StrongPassword' WITH MAX_USER_CONNECTIONS 2;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'mysqld_exporter'@'localhost';
FLUSH PRIVILEGES;
EXIT
```

create the user and folder's to handle the mysql exporter process itself. So we are aware of user-based processes and permissions.

```bash
sudo useradd --no-create-home -c "Monitoring user" --shell /bin/false mysqld_exporter
```

_download the mysql exporter binary_

```bash
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.14.0/mysqld_exporter-0.14.0.linux-amd64.tar.gz
tar -vxzf mysqld_exporter-0.14.0.linux-amd64.tar.gz
sudo mv mysqld_exporter-0.14.0.linux-amd64/mysqld_exporter /usr/local/bin/
sudo chown -R mysqld_exporter:mysqld_exporter  /usr/local/bin/mysqld_exporter
```

_create the mysql credentials as a file_

```bash
# sudo vim /etc/.mysqld_exporter.cnf
[client]
user=mysqld_exporter
password=StrongPassword
```
_assign a permission_

```bash
sudo chown root:mysqld_exporter /etc/.mysqld_exporter.cnf
```

__
sudo vim /etc/systemd/system/mysql_exporter.service

```bash
[Unit]
Description=Prometheus MySQL Exporter
After=network.target

[Service]
Type=simple
User=mysqld_exporter
Restart=always
ExecStart=/usr/local/bin/mysqld_exporter \
  --config.my-cnf /etc/.mysqld_exporter.cnf \
  --collect.global_status \
  --collect.info_schema.innodb_metrics \
  --collect.auto_increment.columns \
  --collect.info_schema.processlist \
  --collect.binlog_size \
  --collect.info_schema.tablestats \
  --collect.global_variables \
  --collect.info_schema.query_response_time \
  --collect.info_schema.userstats \
  --collect.info_schema.tables \
  --collect.perf_schema.tablelocks \
  --collect.perf_schema.file_events \
  --collect.perf_schema.eventswaits \
  --collect.perf_schema.indexiowaits \
  --collect.perf_schema.tableiowaits \
  --collect.slave_status \
  --web.listen-address=0.0.0.0:9104

[Install]
WantedBy=multi-user.target
```


```bash
sudo systemctl daemon-reload
sudo systemctl enable mysql_exporter
sudo systemctl start mysql_exporter
sudo netstat -tulpn
```


switch to prometheus server

```bash

# vim /etc/prometheus/prometheus.yml
# add the new server with new nodeexporter
  - job_name: 'mysql'
    static_configs: 
    - targets: ['localhost:9104']    # MySQL address
      labels: 
        instance: mysql-server
```

```bash
sudo systemctl restart prometheus
```
