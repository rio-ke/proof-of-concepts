
aks kubernetes pods logs

```sql
let startTimestamp = ago(1h);
KubePodInventory
| where TimeGenerated > startTimestamp
| project ContainerID, PodName=Name
| distinct ContainerID, PodName
| join
(
    ContainerLog
    | where TimeGenerated > startTimestamp
)
on ContainerID
| project TimeGenerated, PodName, LogEntry, LogEntrySource
| order by TimeGenerated desc
```


within namespace logs

```sql
let startTimestamp = ago(1h);
KubePodInventory
| where TimeGenerated > startTimestamp
| where Namespace == 'kube-system'
| project Namespace, ContainerID, PodName=Name
| distinct Namespace, ContainerID, PodName
| join
(
    ContainerLog
    | where TimeGenerated > startTimestamp
)
on ContainerID
| project Namespace, TimeGenerated, PodName, LogEntry, LogEntrySource
| order by TimeGenerated desc
```

based on labels pod

```sql
let startTimestamp = ago(5d);
KubePodInventory
| where TimeGenerated > startTimestamp
| project ContainerID, PodName=Name, PodLabel, PodLabelJson=parsejson(PodLabel)
// Label filter: for example, if the pod contains "app: backend" label, then app would be the key, and backend would be the value
| where PodLabelJson[0]["app"] == "backend"
| distinct ContainerID, PodName, PodLabel
| join
(
    ContainerLog
    | where TimeGenerated > startTimestamp
)
on ContainerID
| project TimeGenerated, PodName, LogEntry, LogEntrySource, PodLabel
| order by TimeGenerated desc
```
