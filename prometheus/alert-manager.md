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
