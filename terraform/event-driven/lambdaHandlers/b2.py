import json
import boto3
import os

snsClient = boto3.client('sns')


snsArn = tagvalue = os.environ['snsArn']  # snsArn="arn:aws:sns:ap-south-1:653413855845:b3-sns.fifo"

def lambda_handler(event, context):
    snsClient.publish(MessageGroupId="stageTwo",TargetArn=snsArn, Message=json.dumps({'default': json.dumps(event)}), MessageStructure='json')
    print(f'=> event published to sns')
