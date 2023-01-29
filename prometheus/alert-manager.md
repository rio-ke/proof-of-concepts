
create the user and folder's to handle the node exporter process itself. So we are aware of user-based processes and permissions.

```bash
    sudo useradd --no-create-home -c "alert user" --shell /bin/false alertuser
```

_download the binary_

```bash
    wget https://github.com/prometheus/alertmanager/releases/download/v0.21.0/alertmanager-0.21.0.linux-amd64.tar.gz
    tar -xvzf alertmanager-0.21.0.linux-amd64.tar.gz
    mv alertmanager-0.21.0.linux-amd64/alertmanager /usr/local/bin/
    mv alertmanager-0.21.0.linux-amd64/amtool /usr/local/bin/
```

_permission access for alertuser_

```bash
    sudo chown -R alertuser:alertuser /usr/local/bin/alertmanager
    sudo chown -R alertuser:alertuser /usr/local/bin/amtool
```

_alertmanager configuration_

```bash
sudo mkdir /etc/alertmanager/ 
sudo mkdir /var/alertmanager/
```

_create the notification templates_

create the file under this location `/etc/alertmanager` with the name of `notifications.tmpl` include the below content

```j2
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
```

_create the alartmanager configuration_

create the file under this location `/etc/alertmanager` with the name of `alertmanager.yml` include the below content

```bash
global:
  resolve_timeout: 30s

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

- name: 'slack'
  slack_configs:
  - send_resolved: true
    channel: '#general'
    slack_api_url: 'https://hooks.slack.com/services'
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
- name: "email"
  email_configs:
  - to: "receiver_mail_id@gmail.com"
    from: "mail_id@gmail.com"
    smarthost: smtp.gmail.com:587
    auth_username: "mail_id@gmail.com"
    auth_identity: "mail_id@gmail.com"
    auth_password: "password"
```
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
