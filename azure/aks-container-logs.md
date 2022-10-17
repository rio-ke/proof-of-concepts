
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
