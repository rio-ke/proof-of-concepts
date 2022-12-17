
aws-ec2-instance-metadata-update.md

_create a file with all instance ids._

```txt
# main.txt
i-zbfdg
i-23scvb
```

_create a shell script to change all the metadata version_

```bash

#!/usr/bin/env bash

instanceDetails=$(cat main.txt)

for instance in $instanceDetails;
do
    aws ec2   modify-instance-metadata-options --instance-id  $instance --http-tokens required  --http-endpoint enabled
done

```
