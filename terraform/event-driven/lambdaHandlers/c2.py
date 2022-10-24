import json
import boto3
import os

snsClient = boto3.client('sns')

snsArn = os.environ['snsArn']

def lambda_handler(event, context):
    returnResponse = snsClient.publish(MessageGroupId="stagethree", TargetArn=snsArn, Message=json.dumps({
        'default': json.dumps(event)}), MessageStructure='json')
    print(json.dumps(returnResponse))
