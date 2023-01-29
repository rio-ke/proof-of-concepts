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


_custom systemd service_

For the time being, I am going to add only the prometheus service to monitor prometheus itself.

create the file under this location `/etc/systemd/system` with the name of `mysql_exporter.service` include the below content

```bash
# /etc/systemd/system/mysql_exporter.service
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

_service management_

```bash
sudo systemctl daemon-reload
sudo systemctl enable mysql_exporter
sudo systemctl start mysql_exporter
sudo netstat -tulpn
```

_how to integrate mysql exporter into prometheus_

switch to prometheus server below the configuration must be updated 

```
# vim /etc/prometheus/prometheus.yml
# add the new server with new node exporter
  - job_name: 'mysql'
    static_configs: 
    - targets: ['10.0.1.5:9104']     # server IP address
      labels: 
        instance: db-server         # server name

```


_validate the prometheus configuration_

after the update to the Prometheus configuration. your config file looks like below this.

```bash
---
global:
  scrape_interval:     15s      # default 1m
  evaluation_interval: 15s      # default 1m
  scrape_timeout: 10s           # default 10s

# # Alertmanager configuration
# alerting:
#   alertmanagers:
#   - static_configs:
#     - targets:
#       - alertmanager:9093

# # Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
# rule_files:
#   - "/etc/prometheus/rules.yml"
#   - "/etc/prometheus/add-rules.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']
      labels: 
        instance: Prometheus
  - job_name: 'node'
    static_configs: 
    - targets: ['10.0.1.3:9100']     # server address 
      labels: 
        instance: app-server         # server name
    - targets: ['10.0.1.4:9100']     # server address 
      labels: 
        instance: web-server         # server name
  - job_name: 'mysql'
    static_configs: 
    - targets: ['10.0.1.5:9104']     # server IP address
      labels: 
        instance: db-server          # server name
```

_restart the prometheus service_

```bash
sudo systemctl restart prometheus
``` 
