_aws-sns-lambda-sns-publisher_

```py
import boto3
import json
import os

SNS_ARN = os.environ['SNS_ARN']
REGION = os.environ['REGION']

def get_instance_name(fid):
    ec2 = boto3.resource('ec2', region_name=REGION)
    ec2instance = ec2.Instance(fid)
    instancename = ''
    for tags in ec2instance.tags:
        if tags["Key"] == 'Name':
            instancename = tags["Value"]
    return instancename

def lambda_handler(event, context):
    client = boto3.client('sns')

    message = event['Records'][0]['Sns']['Message']

    _msg = json.loads(message)

    _msg["instanceName"] = get_instance_name(_msg['detail']['instance-id'])
    print(_msg)
    response = client.publish(
        TopicArn=SNS_ARN,
        Message=json.dumps(_msg), 
        Subject="EC2InstanceEvents"
    )
    print(response)
    return response
```
