

```py
import boto3
import json
def send_message():
    sqs_client = boto3.client("sqs")

    message = {"key": "value"}
    response = sqs_client.send_message(
        QueueUrl="https://sqs.ap-southeast-1.amazonaws.com/676487226531/lambda.fifo",
        MessageBody=json.dumps(message),
        MessageGroupId="stageOne"
    )
    print(response)

print(send_message())

sts = boto3.client("sts")
print(sts.get_caller_identity())
account_id = sts.get_caller_identity()["Account"]
```

```py
import boto3
import json

sqsURL="https://sqs.ap-southeast-1.amazonaws.com/676487226531/lambda.fifo"

def send_message(sqsURL,groupId, objectJSON):
    sqs_client = boto3.client("sqs")
    response = sqs_client.send_message(
        QueueUrl=sqsURL,
        MessageBody=json.dumps(objectJSON),
        MessageGroupId=groupId
    )
    print(response)

objectJSON = {"key": "value"}
groupId="stageOne"
print(send_message(sqsURL, groupId, objectJSON))

sts = boto3.client("sts")
print(sts.get_caller_identity())
account_id = sts.get_caller_identity()["Account"]
```
