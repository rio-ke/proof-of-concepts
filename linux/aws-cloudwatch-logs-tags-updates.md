#### aws-cloudwatch-logs-tags-updates.md
---

```bash
#!/usr/bin/env bash


# cloudwatch.sh

cloudwatchGroupARN=$(aws logs describe-log-groups | jq '.logGroups[].logGroupName' | tr -d '"')

for Name in $cloudwatchGroupARN; do
    echo $Name
    sleep 1
    aws logs tag-log-group --log-group-name $Name --tags Key=map-xxxx,Value=d-server-xxxx
done

```

_execution_

```bash

bash cloudwatch.sh

```
