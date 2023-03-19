
```py
import boto3
import json
import os
import requests



SNS_ARN = os.environ['SNS_ARN']
REGION = os.environ['REGION']
SLACK_URL = os.environ['SLACK_URL']

def get_instance_name(fid):
    ec2 = boto3.resource('ec2', region_name=REGION)
    ec2instance = ec2.Instance(fid)
    instancename = ''
    for tags in ec2instance.tags:
        if tags["Key"] == 'Name':
            instancename = tags["Value"]
    return instancename

def send_slack_message(payload, webhook):
    return requests.post(webhook, json.dumps(payload))

def lambda_handler(event, context):
    client = boto3.client('sns')
    print(event)

    message = event['Records'][0]['Sns']['Message']
    print("break")
    print(message)

    _msg = json.loads(message)

    _msg["instanceName"] = get_instance_name(_msg['detail']['instance-id'])

    # SLACK_URL = "https://hooks.slack.com/services/XXXX/XXXX/XXXX"
    payload = {"text": json.dumps(_msg)}
    slackResponse = send_slack_message(payload, SLACK_URL)
    print(slackResponse)

    response = client.publish(
        TopicArn=SNS_ARN,
        Message=json.dumps(_msg), 
        Subject="EC2InstanceEvents"
    )
    return response
```
