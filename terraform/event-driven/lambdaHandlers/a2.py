import json
import boto3
import os

snsClient = boto3.client('sns')
_infraZone = os.environ['infraZone']
snsArn = os.environ['snsArn']

def lambda_handler(event, context):
    modifiedEvents = event['Records']
    extraAttribute = {"zone": _infraZone}
    [rearrange.update(extraAttribute) for rearrange in modifiedEvents]
    returnResponse = snsClient.publish(MessageGroupId="stageone", TargetArn=snsArn, Message=json.dumps(
        {'default': json.dumps(modifiedEvents)}), MessageStructure='json')
    print(json.dumps(returnResponse))