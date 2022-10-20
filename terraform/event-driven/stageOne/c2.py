import json
import boto3
import os

snsClient = boto3.client('sns')

snsArn = os.environ['snsArn']  # "arn:aws:sns:ap-south-1:653413855845:c3-sns.fifo"

def lambda_handler(event, context):
    response = snsClient.publish(MessageGroupId="stagethree",TargetArn=snsArn, Message=json.dumps({'default': json.dumps(event)}), MessageStructure='json')
    print(f' <= event published to sns')
