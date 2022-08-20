aws-cloudwatch-alaram-tags-updates.md
---


```bash
#!/usr/bin/env bash

cloudwatchAlaramARN=$(aws cloudwatch describe-alarms | jq '.MetricAlarms[].AlarmArn' | tr -d '"')

for ARN in $cloudwatchAlaramARN; do
    echo $ARN 
    sleep 1
    aws cloudwatch tag-resource --resource-arn $ARN --tags Key=map-migrated,Value=xxxxxx
done
```
