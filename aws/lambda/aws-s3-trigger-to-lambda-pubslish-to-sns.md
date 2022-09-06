

```py
import json
import boto3

snsClient = boto3.client('sns')

snsArn="arn:aws:sns:ap-southeast-1:653413855845:demo"
def lambda_handler(event, context):
    response = snsClient.publish(
        TargetArn=snsArn,
        Message=json.dumps({'default': json.dumps(event)}),
        MessageStructure='json'
    )
    return response
```
