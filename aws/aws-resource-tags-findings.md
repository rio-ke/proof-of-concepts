```bash
#!/usr/bin/env bash
ARN=$(aws resourcegroupstaggingapi get-resources | jq '.ResourceTagMappingList[] | select(contains({Tags: [{Key: "map-migrated"} ]}) | not)' | jq '.ResourceARN' | base64 )

for RESOURCE_ARN in $ARN; do 
    echo $RESOURCE_ARN | base64 -d
    sleep 1
    # AWS SUPPORT REQUIRED
    #  aws ssm   add-tags-to-resource --resource-type --resources-arn  --tags  map-migrated=d-server-XXX
done

```
