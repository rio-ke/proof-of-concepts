_prometheus-alerts_

```bash
# vim /etc/prometheus/linux.yml

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

```


_Grafana configuration_

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

