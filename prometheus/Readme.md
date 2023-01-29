_prometheus installation_

create the user and folder's to handle the prometheus process itself. So we are aware of user-based processes and permissions.

```bash
sudo useradd --no-create-home -c "Monitoring user" --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
```

_download the prometheus binary_

```bash
sudo apt install wget tar -y
wget https://github.com/prometheus/prometheus/releases/download/v2.41.0/prometheus-2.41.0.linux-amd64.tar.gz
tar -vxzf prometheus-2.41.0.linux-amd64.tar.gz
mv prometheus-2.41.0.linux-amd64 prometheus-files
```

_permission management_

We should provide the appropriate permissions that are required for all binaries.

```bash
sudo mv prometheus-files/prometheus /usr/local/bin/
sudo mv prometheus-files/promtool /usr/local/bin/
sudo mv prometheus-files/tsdb /usr/local/bin/

sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo chown prometheus:prometheus /usr/local/bin/tsdb

sudo mv prometheus-files/prometheus.yml /etc/prometheus/
sudo mv prometheus-files/consoles /etc/prometheus
sudo mv prometheus-files/console_libraries /etc/prometheus

sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown -R prometheus:prometheus  /var/lib/prometheus
sudo chown -R prometheus:prometheus  /etc/prometheus/prometheus.yml
```

_prepare the prometheus configuiration yaml file_

For the time being, I am going to add only the prometheus service to monitor prometheus itself.

create the file under this location `/etc/prometheus` with the name of `prometheus.yml` include the below content

```bash
# /etc/prometheus/prometheus.yml
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
        instance: prometheus
```

_custom systemd service_

to supervise the prometheus service We can easily create the systemd service in Linux, and we can be aware of how we can start and stop those binaries.

```bash
# sudo vim /etc/systemd/system/prometheus.service 

[Unit]
Description=Prometheus Monitoring service
After=network.target auditd.service

[Service]
Type=simple
WorkingDirectory=/var/lib/prometheus
User=prometheus
ExecStart=/usr/local/bin/prometheus \
 --config.file=/etc/prometheus/prometheus.yml \
 --storage.tsdb.path=/var/lib/prometheus/data/ \
 --web.console.templates=/etc/prometheus/consoles \
 --web.console.libraries=/etc/prometheus/console_libraries \
 --storage.tsdb.retention=30d \
 --web.enable-admin-api \
 --web.external-url=http://localhost:10000 \
 --web.listen-address="0.0.0.0:10000" \
 --log.level=info \
 --web.enable-lifecycle \
 --web.page-title="Prometheus Time Series Collection and Processing Server" \
 --log.format=logfmt

Restart=always
StandardOutput=syslog
StandardError=syslog

[Install]
WantedBy=default.target
```

_service management_

```bash
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl status prometheus
sudo netstat -tulpn | grep 9090
```

_node exporter installation_

In order to monitor the linux server performance and process based activity via prometheus each instance should have run to the node exporter as a service. the prometheus pull the metric from node exporter via api and store it self to maintain the upon to max duration time.

create the user and folder's to handle the node exporter process itself. So we are aware of user-based processes and permissions.

```bash
sudo useradd --no-create-home -c "Monitoring user" --shell /bin/false node_exporter
```

_download the node exporter binary_

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar -vxzf node_exporter-1.5.0.linux-amd64.tar.gz
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/
sudo chown -R node_exporter:node_exporter  /usr/local/bin/node_exporter
```


_create the custom systemd service for node exportor _

create the file under this location `/etc/systemd/system` with the name of `node_exporter.service` include the below content

```bash
# /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus node exporter
After=network.target auditd.service

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter \
  --web.listen-address=0.0.0.0:9100 \
  --collector.tcpstat \
  --collector.bonding \
  --collector.systemd \
  --collector.systemd.unit-whitelist=(sshd|httpd|node_exporter|vsftpd|crond|firewalld|rsyslog).service \
  --collector.meminfo_numa \
  --collector.logind \
  --collector.filesystem.ignored-mount-points "^(/snap/|/run/|/dev/|/sys|/run).*" \
  --no-collector.wifi \
  --no-collector.nfs \
  --no-collector.zfs \
  --no-collector.nfsd \
  --no-collector.mdadm \
  --no-collector.arp \
  --no-collector.bcache \
  --no-collector.buddyinfo \
  --no-collector.edac \
  --no-collector.hwmon \
  --no-collector.qdisc \
  --no-collector.infiniband \
  --collector.ipvs 
  #--path.procfs=/proc 
Restart=on-failure
StandardOutput=syslog
StandardError=syslog
[Install]
WantedBy=default.target
```

_service management_

```bash
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter
sudo netstat -tulpn 
```

switch to prometheus server

    # need to change prometheus server.
    # vim /etc/prometheus/prometheus.yml
    # add the new server with new nodeexporter
      - job_name: 'nodeexporter'
        static_configs: 
        - targets: ['localhost:9100']    # server IP address
          labels: 
            instance: Prometheus-server  # server name
        # add the new server with existing nodeexporter
        - targets: ['10.0.1.4:9100']     # server IP address
          labels: 
            instance: additional-server  # server name


        sudo systemctl restart prometheus
        
        
        

mysql exporter installtion

    # install mysql exporter MariaDB mysql [Each Server]
    sudo useradd --no-create-home -c "Monitoring user" --shell /bin/false mysqld_exporter
    wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.12.1/mysqld_exporter-0.12.1.linux-amd64.tar.gz
    tar -vxzf mysqld_exporter-0.12.1.linux-amd64.tar.gz
    sudo mv mysqld_exporter-0.12.1.linux-amd64/mysqld_exporter /usr/local/bin/
    sudo chown -R mysqld_exporter:mysqld_exporter  /usr/local/bin/mysqld_exporter


    # its need mysql server (Require new installtion)
    sudo apt install mysql-server
    sudo systemctl start mysql
    sudo mysql_secure_installtion
    sudo mysql -u root -p 

    # Create Mysql user for mysqld_exporter

    CREATE USER 'mysqld_exporter'@'localhost' IDENTIFIED BY 'StrongPassword' WITH MAX_USER_CONNECTIONS 2;
    GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'mysqld_exporter'@'localhost';
    FLUSH PRIVILEGES;
    EXIT

    sudo vim /etc/.mysqld_exporter.cnf

    [client]
    user=mysqld_exporter
    password=StrongPassword


    sudo chown root:mysqld_exporter /etc/.mysqld_exporter.cnf

    sudo vim /etc/systemd/system/mysql_exporter.service

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


    sudo systemctl daemon-reload
    sudo systemctl enable mysql_exporter
    sudo systemctl start mysql_exporter
    sudo netstat -tulpn

switch to prometheus server

    # need to change prometheus server.
    # vim /etc/prometheus/prometheus.yml
    
    # add the new server with new nodeexporter
      - job_name: 'mysqlexporter'
        static_configs: 
        - targets: ['localhost:9104']    # MySQL IP address
          labels: 
            instance: mysql-server


        sudo systemctl restart prometheus

pushgateway installation

    # PushGateway
    sudo useradd --no-create-home -c "Monitoring user" --shell /bin/false pushgateway
    wget https://github.com/prometheus/pushgateway/releases/download/v1.2.0/pushgateway-1.2.0.linux-amd64.tar.gz
    tar -xvzf pushgateway-1.2.0.linux-amd64.tar.gz
    mv pushgateway-1.2.0.linux-amd64/pushgateway /usr/local/bin/
    sudo chown -R pushgateway:pushgateway /usr/local/bin/pushgateway


    sudo vim /etc/systemd/system/pushgateway.service
    [Unit]
    Description=Pushgateway
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=pushgateway
    Group=pushgateway
    Type=simple
    ExecStart=/usr/local/bin/pushgateway \
        --web.listen-address=":9091" \
        --web.telemetry-path="/metrics" \
        --persistence.file="/tmp/metric.store" \
        --persistence.interval=5m \
        --log.level="info" 

    [Install]
    WantedBy=multi-user.target

    sudo systemctl daemon-reload
    sudo systemctl enable pushgateway
    sudo systemctl start pushgateway
    sudo netstat -tulpn

switch to prometheus server

    # need to change prometheus server.
    # vim /etc/prometheus/prometheus.yml
    
    # add the new server with new nodeexporter
      - job_name: 'pushgatewayexporter'
        static_configs: 
        - targets: ['localhost:9091']    # PushGateway IP address
          labels: 
            instance: pushgateway


        sudo systemctl restart prometheus

PushGateway tasks

    echo "some_metric 3.14" | curl --data-binary @- http://localhost:9091/metrics/job/cron_job/instance/127.0.0.0

    # to find the metrics
    curl -L http://localhost:9091/metrics/

    # if you want delete the request
    curl -X DELETE http://localhost:9091/metrics/job/cron_job/instance/127.0.0.0
    
    
    test cron
    
    #!/usr/bin/env bash

        # filename: cron_batchtrigger.sh

        # Environment Labels Name
        #    jobname: batchtrigger
        #    instance: 127.0.0.1

        command=$(curl -s -o /dev/null -I -w "%{http_code}" https://google.com)
        if [ $command == 200 ]; then
            echo "login_trigger 0" | curl --data-binary @- http://localhost:9091/metrics/job/batchtrigger/instance/127.0.0.0
        else
            echo "login_trigger 1" | curl --data-binary @- http://localhost:9091/metrics/job/batchtrigger/instance/127.0.0.0
        fi

        # bash cron_batchtrigger.sh


Grafana installtion

        sudo apt-get install -y apt-transport-https
        sudo apt-get install -y software-properties-common wget
        wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
        echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list 
        sudo apt-get update
        sudo apt-get install grafana
        sudo systemctl daemon-reload
        sudo systemctl start grafana-server
        sudo systemctl status grafana-server
        sudo systemctl enable grafana-server.service
        
        open browser http://[SERVERIP]:3000

Alert Manager

    sudo useradd --no-create-home -c "Monitoring user" --shell /bin/false alertuser
    wget https://github.com/prometheus/alertmanager/releases/download/v0.21.0/alertmanager-0.21.0.linux-amd64.tar.gz
    tar -xvzf alertmanager-0.21.0.linux-amd64.tar.gz

    mv alertmanager-0.21.0.linux-amd64/alertmanager /usr/local/bin/
    mv alertmanager-0.21.0.linux-amd64/amtool /usr/local/bin/

    sudo chown -R alertuser:alertuser /usr/local/bin/alertmanager
    sudo chown -R alertuser:alertuser /usr/local/bin/amtool

    sudo mkdir /etc/alertmanager/ 
    sudo mkdir /var/alertmanager/

    sudo vim /etc/alertmanager/notifications.tmpl

    {{ define "__single_message_title" }}{{ range .Alerts.Firing }}{{ .Labels.alertname }} @ {{ .Annotations.identifier }}{{ end }}{{ range .Alerts.Resolved }}{{ .Labels.alertname }} @ {{ .Annotations.identifier }}{{ end }}{{ end }}

    {{ define "custom_title" }}[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ if or (and (eq (len .Alerts.Firing) 1) (eq (len .Alerts.Resolved) 0)) (and (eq (len .Alerts.Firing) 0) (eq (len .Alerts.Resolved) 1)) }}{{ template "__single_message_title" . }}{{ end }}{{ end }}

    {{ define "custom_slack_message" }}
    {{ if or (and (eq (len .Alerts.Firing) 1) (eq (len .Alerts.Resolved) 0)) (and (eq (len .Alerts.Firing) 0) (eq (len .Alerts.Resolved) 1)) }}
    {{ range .Alerts.Firing }}{{ .Annotations.description }}{{ end }}{{ range .Alerts.Resolved }}{{ .Annotations.description }}{{ end }}
    {{ else }}
    {{ if gt (len .Alerts.Firing) 0 }}
    *Alerts Firing:*
    {{ range .Alerts.Firing }}- {{ .Annotations.identifier }}: {{ .Annotations.description }}
    {{ end }}{{ end }}
    {{ if gt (len .Alerts.Resolved) 0 }}
    *Alerts Resolved:*
    {{ range .Alerts.Resolved }}- {{ .Annotations.identifier }}: {{ .Annotations.description }}
    {{ end }}{{ end }}
    {{ end }}
    {{ end }}

    sudo vim /etc/alertmanager/alertmanager.yml

    global:
      resolve_timeout: 30s
      slack_api_url: 'https://hooks.slack.com/services'
      smtp_from: 'example@gmail.com'
      smtp_smarthost: smtp.gmail.com:587
      smtp_auth_username: 'example@gmail.com'
      smtp_auth_identity: 'example@gmail.com'
      smtp_auth_password: 'fqkv kumo rgaq gkat'

    templates:
    - /etc/alertmanager/notifications.tmpl

    route:
      # fallback receiver
      receiver: admin
      group_wait: 2m
      group_interval: 10s
      repeat_interval: 1m
      routes:
      - match_re:
          app_type: (linux|windows)
        # fallback receiver 
        receiver: ss-admin
        # group_by: [severity]
        routes:
        # Linux team
        - match:
            app_type: linux
          # fallback receiver
          receiver: linux-teamlead
          routes:
          - match:
              severity: critical
            receiver: delivery-manager
          - match:
              severity: warning
            receiver: linux-teamlead

        # Windows team
        - match:
            app_type: windows
          # group_by: [severity]
          # fallback receiver
          receiver: windows-teamlead
          routes:
          - match:
              severity: critical
            receiver: delivery-manager
          - match:
              severity: warning
            receiver: windows-teamlead

        # test Technologies.
      - match_re:
          app_type: (python|go)
        # fallback receiver 
        receiver: pec-admin
        routes:
        # Python team
        - match:
            app_type: python
          # fallback receiver
          receiver: python-team-admin
          routes:
          - match:
              severity: critical
            receiver: python-team-manager
          - match:
              severity: warning
            receiver: python-team-lead

        # Go team
        - match:
            app_type: go
          # fallback receiver
          receiver: go-team-admin
          routes:
          - match:
              severity: critical
            receiver: go-team-manager
          - match:
              severity: warning
            receiver: go-team-lead

    inhibit_rules:
    - source_match:
        severity: 'critical'
      target_match:
        severity: 'warning'
      equal: ['app_type', 'category']

    receivers:
    - name: admin
      email_configs:
      - to: 'example@gmail.com'
    - name: ss-admin
      email_configs:
      - to: 'example@gmail.com'
    - name: linux-team-admin
      email_configs:
      - to: 'example@gmail.com'
    - name: linux-team-lead
      email_configs:
      - to: 'example@gmail.com'
    - name: linux-team-manager
      email_configs:
      - to: 'example@gmail.com'
    - name: windows-team-admin
      email_configs:
      - to: 'example@gmail.com'
    - name: windows-team-lead
      email_configs:
      - to: 'example@gmail.com'
    - name: windows-team-manager
      email_configs:
      - to: 'example@gmail.com'
    - name: pec-admin
      email_configs:
      - to: 'example@gmail.com'
    - name: python-team-admin
      email_configs:
      - to: 'example@gmail.com'
    - name: python-team-lead
      email_configs:
      - to: 'example@gmail.com'
    - name: python-team-manager
      email_configs:
      - to: 'example@gmail.com'
    - name: go-team-admin
      email_configs:
      - to: 'example@gmail.com'

    - name: go-team-lead
      email_configs:
      - to: 'example@gmail.com'

    - name: go-team-manager
      email_configs:
      - to: 'example@gmail.com'

    - name: 'slack_alerts_channel'
      slack_configs:
      - send_resolved: true
        channel: '#general'
    #    title: '{{ template "custom_title" . }}'
    #    text: '{{ template "custom_slack_message" . }}'
        title: '{{ .Status | toUpper }}{{ if eq .Status "firing" }} - {{ .Alerts.Firing | len }}{{ end }} | JINO PROMETHEUS ALERTS'
        text: >-
          {{ range .Alerts }}
            *Alert:* {{ .Annotations.summary }}
            *State:* `{{ .Labels.severity }}`
            *Description:* {{ .Annotations.description }}
            *Graph:* <{{ .GeneratorURL }}|:chart_with_upwards_trend:>
            *Details:*
            {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
            {{ end }}
          {{ end }}

    sudo vim /etc/systemd/system/alertmanager.service

    [Unit]
    Description=Prometheus AlertManager
    After=network.target auditd.service

    [Service]
    User=alertuser
    ExecStart=/usr/local/bin/alertmanager --config.file "/etc/alertmanager/alertmanager.yml" --storage.path "/var/alertmanager/data/"
    Restart=on-failure
    StandardOutput=syslog
    StandardError=syslog

    [Install]
    WantedBy=default.target

    sudo systemctl daemon-reload
    sudo systemctl enable alertmanager
    sudo systemctl start alertmanager
    sudo netstat -tulpn
    sudo systemctl status alertmanager

Alert Rules

    vim /etc/prometheus/linux.yml
    
    groups:
      - name: linux-rules
        rules:

        - alert: NodeExporterDown
          expr: up{job="node_exporter"} == 0
          for: 2m
          labels:
            severity: critical
            app_type: linux
            category: server
          annotations:
            summary: "Node Exporter is down"
            description: "Node Exporter is down for more than 2 minutes"

        - record: job:node_memory_Mem_bytes:available
          expr: (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100

        - alert: NodeMemoryUsageAbove60%
          expr: 60 < (100 - job:node_memory_Mem_bytes:available) < 75
          for: 2m
          labels:
            severity: warning
            app_type: linux
            category: memory
          annotations:
            summary: "Node memory usage is going high"
            description: "Node memory for instance {{ $labels.instance }} has reached {{ $value }}%"
            app_link: 'http://localhost:8000/'
            
        - alert: NodeMemoryUsageAbove75%
          expr: (100 - job:node_memory_Mem_bytes:available) >= 75
          for: 2m
          labels:
            severity: critical
            app_type: linux
            category: memory
          annotations:
            summary: "Node memory usage is very HIGH"
            description: "Node memory for instance {{ $labels.instance }} has reached {{ $value }}%"

        - alert: NodeCPUUsageHigh
          expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[1m])) * 100) > 80
          for: 2m
          labels:
            severity: critical
            app_type: linux
            category: cpu
          annotations:
            summary: "Node CPU usage is HIGH"
            description: "CPU load for instance {{ $labels.instance }} has reached {{ $value }}%"

        - alert: NodeCPU_0_High
          expr: 100 - (avg by(instance, cpu) (irate(node_cpu_seconds_total{mode="idle", cpu="0"}[1m])) * 100) > 80
          for: 2m
          labels:
            severity: critical
            app_type: linux
            category: cpu
          annotations:
            summary: "Node CPU_0 usage is HIGH"
            description: "CPU_0 load for instance {{ $labels.instance }} has reached {{ $value }}%"

        - alert: NodeCPU_1_High
          expr: 100 - (avg by(instance, cpu) (irate(node_cpu_seconds_total{mode="idle", cpu="1"}[1m])) * 100) > 80
          for: 2m
          labels:
            severity: critical
            app_type: linux
            category: cpu
          annotations:
            summary: "Node CPU_1 usage is HIGH"
            description: "CPU_1 load for instance {{ $labels.instance }} has reached {{ $value }}%"

        - alert: NodeFreeDiskSpaceLess30%
          expr: (sum by (instance) (node_filesystem_free_bytes) / sum by (instance) (node_filesystem_size_bytes)) * 100 < 30
          for: 2m
          labels:
            severity: warning
            app_type: linux
            category: disk
          annotations:
            summary: "Node free disk space is running out"
            description: "Node disk is going to full (< 30% left)\n  Current free disk space is {{ $value }}"








Grafana Graphics

# Create variables

    job:
      name: group
        value: label_values(node_uname_info, job)
    hostname:
      name: hostname
      value: label_values(node_uname_info{job=~"$job"}, nodename)
    node:
      name: node
      value: label_values(node_uname_info{job=~"$job",nodename=~"$hostname"},instance)


    ignore device references:

    network interface:
      name: device
      value: label_values(node_network_info{device!~'tap.*|veth.*|br.*|docker.*|virbr.*|lo.*|cni.*'},device)

    maxmount - query_result(topk(1,sort_desc (max(node_filesystem_size_bytes{instance=~'$node',fstype=~"ext.?|xfs",mountpoint!~".*pods.*"}) by (mountpoint))))
      regex - /.*\"(.*)\".*/
    show_hostname - label_values(node_uname_info{job=~"$job",instance=~"$node"}, nodename)


    login session count:
      node_logind_sessions > 0

    tcp connection states:
      node_tcp_connection_states > 0
    process state:
      irate(node_forks_total{instance=~"$server"}[$intervel]) or rate(node_forks_total{instance=~"$server"}[1m])

    cpu count:
      count(count(node_cpu_seconds_total{instance=~"$server"}) by (cpu))
    cpu %:
      (((count(count(node_cpu_seconds_total{instance=~"$server"}) by (cpu))) - avg(sum by (mode)(irate(node_cpu_seconds_total{mode='idle',instance=~"$server"}[5m])))) * 100) / count(count(node_cpu_seconds_total{instance=~"$server"}) by (cpu))
    virtual Memory:
      node_memory_MemTotal_bytes{instance=~"$server"} + node_memory_SwapTotal_bytes{instance=~"$server"}
    Memory:
      node_memory_MemTotal_bytes{instance=~"$server"}
    Memory Usage%:
      ((node_memory_MemTotal_bytes{instance=~"$server"} - node_memory_MemFree_bytes{instance=~"$server"})  / (node_memory_MemTotal_bytes{instance=~"$server"})) * 100 
    Memory Available:
      (node_memory_MemAvailable_bytes{instance=~"$server"} or (node_memory_MemFree_bytes{instance=~"$server"} + node_memory_Buffers_bytes{instance=~"$server"} + node_memory_Cached_bytes{instance=~"$server"})) / node_memory_MemTotal_bytes{instance=~"$server"} * 100

    Disk Space:
      sum(avg(node_filesystem_size_bytes{instance=~"$server",fstype=~"(ext.|xfs|vfat)"}) without (mountpoint)) without (device,fstype)
    Disk Free:
      min(node_filesystem_free_bytes{instance=~"$server", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs|shm|overlay"}/node_filesystem_size_bytes{instance=~"$server", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs|shm|overlay"})*100
    Root Size:
      node_filesystem_size_bytes{instance=~"$server",mountpoint="/",fstype!="rootfs"}
    Root Usage:
      100 - ((node_filesystem_avail_bytes{instance=~"$server",mountpoint="/",fstype!="rootfs"} * 100) / node_filesystem_size_bytes{instance=~"$server",mountpoint="/",fstype!="rootfs"})

    Load 1m:
      avg_over_time(node_load1{instance="$server"}[$intervel]) or avg_over_time(node_load1{instance="$server"}[5m])
    Load 5m:
      avg_over_time(node_load5{instance="$server"}[$intervel]) or avg_over_time(node_load5{instance="$server"}[5m])
    Load 15m:
      avg_over_time(node_load15{instance="$server"}[$intervel]) or avg_over_time(node_load15{instance="$server"}[5m])

    swap size:
      node_memory_SwapTotal_bytes{instance=~"$server"}
    Swap Usage:
      ((node_memory_SwapTotal_bytes{instance=~"$server"} - node_memory_SwapFree_bytes{instance=~"$server"})  / (node_memory_SwapFree_bytes{instance=~"$server"})) * 100 


    All Core %:

    clamp_max(sum by () ((avg by (mode) ((clamp_max(rate(node_cpu_seconds_total{instance="$server",mode!="idle",mode!="iowait"}[$intervel]),1)) or (clamp_max(irate(node_cpu_seconds_total{instance="$server",mode!="idle",mode!="iowait"}[5m]),1)) )) *100 or sum by () (avg_over_time(node_cpu_average{instance="$server",mode!="total",mode!="idle"}[$intervel]) or avg_over_time(node_cpu_average{instance="$server",mode!="total",mode!="idle"}[5m])) unless (avg_over_time(node_cpu_average{instance="$server",mode="total",job="rds-basic"}[$intervel]) or avg_over_time(node_cpu_average{instance="$server",mode="total",job="rds-basic"}[5m]))),100)


    user based CPU %:
      clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{instance="$server",mode="user"}[$intervel]),1)) or (clamp_max(irate(node_cpu_seconds_total{instance="$server",mode="user"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{instance="$server", mode="user"}[$intervel]) or avg_over_time(node_cpu_average{instance="$server", mode="user"}[5m]))),100)

    system based CPU%:
      clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{instance="$server",mode="system"}[$intervel]),1)) or (clamp_max(irate(node_cpu_seconds_total{instance="$server",mode="system"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{instance="$server", mode="system"}[$intervel]) or avg_over_time(node_cpu_average{instance="$$server", mode="system"}[5m]))),100)

    other Based CPU%:
      clamp_max(((sum by () (avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{instance="$server",mode!="idle",mode!="user",mode!="system",mode!="iowait",mode!="steal"}[$intervel]),1)) or (clamp_max(irate(node_cpu_seconds_total{instance="$server",mode!="idle",mode!="user",mode!="system",mode!="iowait",mode!="steal"}[5m]),1)) )) *100) or (sum(avg_over_time(node_cpu_average{instance="$server", mode!="total",mode!="idle",mode!="user",mode!="system",mode!="wait",mode!="steal"}[$intervel])) or sum(avg_over_time(node_cpu_average{instance="$server", mode!="total",mode!="idle",mode!="user",mode!="system",mode!="wait",mode!="steal"}[5m])))),100) 

    steal based CPU%:
      clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{instance="$server",mode="steal"}[$intervel]),1)) or (clamp_max(irate(node_cpu_seconds_total{instance="$server",mode="steal"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{instance="$server", mode="steal"}[$intervel]) or avg_over_time(node_cpu_average{instance="$server", mode="steal"}[5m]))),100)

    overall CPU utilization:
      mode:
        clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{instance="$server",mode!="idle"}[$intervel]),1)) or (clamp_max(irate(node_cpu_seconds_total{instance="$server",mode!="idle"}[5m]),1)) ))*100 or (max_over_time(node_cpu_average{instance=~"$server", mode!="total", mode!="idle"}[$intervel]) or max_over_time(node_cpu_average{instance=~"$server", mode!="total", mode!="idle"}[5m]))),100)
      maximum core utilization:
        clamp_max(max by () ((sum  by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{instance="$server",mode!="idle",mode!="iowait"}[$intervel]),1)) or (clamp_max(irate(node_cpu_seconds_total{instance="$server",mode!="idle",mode!="iowait"}[5m]),1)) )*100) or (max_over_time(node_cpu_average{instance=~"$server", mode!="total", mode!="idle", mode!="wait"}[$intervel]) or max_over_time(node_cpu_average{instance=~"$server", mode!="total",mode!="idle", mode!="wait"}[5m]))),100)

    CPU count based utilization:
      avg:
        clamp_max(avg by () ((sum by (cpu) ( (clamp_max(irate(node_cpu_seconds_total{instance="$server",mode!="idle",mode!="iowait"}[5m]),1))*100 )) or max_over_time(node_cpu_average{instance=~"$server", mode!="total",mode!="idle", mode!="wait"}[5m])) ,100)
      cpu:
        clamp_max((sum by (cpu) ( (clamp_max(irate(node_cpu_seconds_total{instance="$server",mode!="idle",mode!="iowait"}[5m])*100,100)) )) or sum by (cpu) (max_over_time(node_cpu_average{instance=~"$server", mode!="total",mode!="idle", mode!="wait"}[5m])) ,100)

    Graphical CPU:
      (1 - avg(irate(node_cpu_seconds_total{instance="$server",mode="idle"}[1m])) by (instance)) * 100

    Saturation Metrics:
      normal CPU Load:
        (avg_over_time(node_procs_running{instance=~"$server"}[$intervel])-1) / scalar(count(node_cpu_seconds_total{instance=~"$server"}))
      IO Load:
        avg_over_time(node_procs_blocked{instance=~"$server"}[$intervel]) or avg_over_time(node_procs_blocked{instance=~"$server"}[5m]) 



    node_uname_info{job=~"$job"} - 0
    sum(time() - node_boot_time_seconds{job=~"$job"})by(instance)
    node_memory_MemTotal_bytes{instance="$node"} - 0
    count(node_cpu_seconds_total{job=~"$job",mode='system'}) by (instance)
    node_load5{job=~"$job"}
    (1 - avg(irate(node_cpu_seconds_total{job=~"$job",mode="idle"}[5m])) by (instance)) * 100
    (1 - (node_memory_MemAvailable_bytes{job=~"$job"} / (node_memory_MemTotal_bytes{job=~"$job"})))* 100
    max((node_filesystem_size_bytes{job=~"$job",fstype=~"ext.?|xfs"}-node_filesystem_free_bytes{job=~"$job",fstype=~"ext.?|xfs"}) *100/(node_filesystem_avail_bytes {job=~"$job",fstype=~"ext.?|xfs"}+(node_filesystem_size_bytes{job=~"$job",fstype=~"ext.?|xfs"}-node_filesystem_free_bytes{job=~"$job",fstype=~"ext.?|xfs"})))by(instance)
    max(irate(node_disk_read_bytes_total{job=~"$job"}[5m])) by (instance)
    max(irate(node_disk_written_bytes_total{job=~"$job"}[5m])) by (instance)
    max(irate(node_network_receive_bytes_total{job=~"$job"}[5m])*8) by (instance)
    max(irate(node_network_transmit_bytes_total{job=~"$job"}[5m])*8) by (instance)

