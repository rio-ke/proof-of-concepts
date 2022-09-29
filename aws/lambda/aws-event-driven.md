

s3 event publish to sns
```py
import json
import boto3

snsClient = boto3.client('sns')
snsArn="arn:aws:sns:ap-south-1:653413855845:a3-sns.fifo"
def lambda_handler(event, context):
    response = snsClient.publish(MessageGroupId="stageone", TargetArn=snsArn, Message=json.dumps({'default': json.dumps(event)}), MessageStructure='json')
    print(f' <= event published to sns')
```

sns.fifo publish to sqs.fifo

![image](https://user-images.githubusercontent.com/57703276/193088995-840eff86-820a-4552-9094-45245a935098.png)

sns queue to lambda trigger

Require params

* Content-based deduplication
* Deduplication scope 
  * Message group
  * per queue
  
_access policy_
```json
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "SQS:SendMessage",
      "Resource": "arn:aws:sqs:ap-south-1:653413855845:*",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:sns:ap-south-1:653413855845:*"
        }
      }
    }
  ]
}
```

![image](https://user-images.githubusercontent.com/57703276/193089188-eafed6f8-6a4f-42b1-bb41-3ccfbc06b8ff.png)
