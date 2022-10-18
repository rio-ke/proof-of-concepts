import json
import boto3
import os

snsClient = boto3.client('sns')

snsArn = tagvalue = os.environ['snsArn']  # "arn:aws:sns:ap-south-1:653413855845:a3-sns.fifo"

def lambda_handler(event, context):
    modifiedEvents = event['Records']
    extraAttribute = {"zone": "internet"}
    [rearrange.update(extraAttribute) for rearrange in modifiedEvents]
    response = snsClient.publish(MessageGroupId="stageone", TargetArn=snsArn, Message=json.dumps(
        {'default': json.dumps(modifiedEvents)}), MessageStructure='json')
    print(f' <= event published to sns')
