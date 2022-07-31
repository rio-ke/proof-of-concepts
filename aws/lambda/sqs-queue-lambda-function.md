## sqs-queue-lambda-function.md

```json
{
  "Records": [
    {
      "messageId": "6d308867-42d3-4cb1-8db6-4986fc84ee04",
      "receiptHandle": "AQEBmKy5eJyQIV4W/YuDAhjTIkdkKxn9TKHTuybT+zq6RdL3kNejs0bpIcFDWzl4NSlqQHgXF1A46qGjLydDdrdZ059wQ6FnbjVB3N9W2mdq9yZkRX+m3zAIVxRG/DqmrjtFb14FQwCgSKx2kFOSZKd/PdGvIk728Mov0qR1wvDTAN7AFiTcUZkfEOmTjEaP5YsTC0DeU7tm2+U+OKk+9WOhphosGKsEG3AiNY/PKhihLPmKC9Wsx0pXJ8Sb7X6PVEHcG877jf/lihTiBYf+Trn1kILxZNsqDRSRTY35jLLx8BvgY+SAXqygYNht8NcuF9RD",
      "body": {
        "Type": "Notification",
        "MessageId": "ae8251ab-ed16-5fa1-aa62-0acbca95693d",
        "SequenceNumber": "10000000000000005000",
        "TopicArn": "arn:aws:sns:ap-southeast-1:653413855845:pre-signed-url-scanner-topic.fifo",
        "Subject": "dodo",
        "Message": "dodo messages",
        "Timestamp": "2022-07-31T06:46:27.662Z",
        "UnsubscribeURL": "https://sns.ap-southeast-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:ap-southeast-1:653413855845:pre-signed-url-scanner-topic.fifo:a2511a07-d037-4f27-8459-64cf6344d857",
        "MessageAttributes": {
          "AWS.SNS.MOBILE.MPNS.TTL": { "Type": "String", "Value": "300" },
          "AWS.SNS.MOBILE.BAIDU.TTL": { "Type": "String", "Value": "300" },
          "AWS.SNS.MOBILE.MACOS_SANDBOX.TTL": {
            "Type": "String",
            "Value": "300"
          },
          "AWS.SNS.MOBILE.MACOS.TTL": { "Type": "String", "Value": "300" },
          "AWS.SNS.MOBILE.GCM.TTL": { "Type": "String", "Value": "300" },
          "AWS.SNS.MOBILE.ADM.TTL": { "Type": "String", "Value": "300" },
          "AWS.SNS.MOBILE.APNS.TTL": { "Type": "String", "Value": "300" },
          "AWS.SNS.MOBILE.APNS_SANDBOX.TTL": {
            "Type": "String",
            "Value": "300"
          },
          "AWS.SNS.MOBILE.APNS_VOIP_SANDBOX.TTL": {
            "Type": "String",
            "Value": "300"
          },
          "AWS.SNS.MOBILE.APNS_VOIP.TTL": { "Type": "String", "Value": "300" },
          "AWS.SNS.MOBILE.WNS.TTL": { "Type": "String", "Value": "300" }
        }
      },
      "attributes": {
        "ApproximateReceiveCount": "1",
        "SentTimestamp": "1659249987689",
        "SequenceNumber": "18871512070557936896",
        "MessageGroupId": "dodo",
        "SenderId": "AIDA2573QF7UDQNDW3ZZA",
        "MessageDeduplicationId": "dodo",
        "ApproximateFirstReceiveTimestamp": "1659249987689"
      },
      "messageAttributes": {},
      "md5OfBody": "293eae35bd099705d7640930ccb16d1a",
      "eventSource": "aws:sqs",
      "eventSourceARN": "arn:aws:sqs:ap-southeast-1:653413855845:pre-signed-url-queue.fifo",
      "awsRegion": "ap-southeast-1"
    }
  ]
}
```

```py
import json

def lambda_handler(event, context):
    queueMessges=event['Records'][0]['body']
    print(queueMessges['Message'])
    return (queueMessges['Message']
```
