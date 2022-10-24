import json
import boto3
import os

snsClient = boto3.client('sns')
_infraZone = os.environ['infraZone']
snsArn = os.environ['snsArn']  # "arn:aws:sns:ap-south-1:653413855845:a3-sns.fifo"

def lambda_handler(event, context):
    modifiedEvents = event['Records']
    extraAttribute = {"zone": _infraZone}
    [rearrange.update(extraAttribute) for rearrange in modifiedEvents]
    snsClient.publish(MessageGroupId="stageone", TargetArn=snsArn, Message=json.dumps(
        {'default': json.dumps(modifiedEvents)}), MessageStructure='json')
    print(f'=> event published to sns')
