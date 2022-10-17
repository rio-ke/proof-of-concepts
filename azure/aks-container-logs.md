
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
// at this point before the next pipe, columns from both tables are available to be "projected". Due to both 
// tables having a "Name" column, we assign an alias as PodName to one column which we actually want
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
// at this point before the next pipe, columns from both tables are available to be "projected". Due to both 
// tables having a "Name" column, we assign an alias as PodName to one column which we actually want
| project Namespace, TimeGenerated, PodName, LogEntry, LogEntrySource
| order by TimeGenerated desc
```
