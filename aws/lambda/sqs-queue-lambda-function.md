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
        "Message": {
          "presignedUrl": "https://pre-signed-url-local.s3.amazonaws.com/ssh.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAZQIUAGJSS4G2DGMF%2F20220731%2Fap-southeast-1%2Fs3%2Faws4_request&X-Amz-Date=20220731T083215Z&X-Amz-Expires=600&X-Amz-SignedHeaders=host&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEOn%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLXNvdXRoZWFzdC0xIkcwRQIhAMGSR729lnw7hgkyYz5hQqggOL4PN7alp7siok3Vuq3MAiAruXcr7i39gER3%2Fn9aK5WZd1Lvf8w%2BfKyLZYYTB1j01ir3AghCEAAaDDY1MzQxMzg1NTg0NSIMZtt%2Ft6230pcWXmn2KtQCCeJUAehul%2Fy%2FHEkODCWm6znWXdQmSpUeDfzUkmVvNFCWrRHE5wpbEePfrOrWmz7af9gNTvxKpucPHQnnpYsvwnUZRFzrmHbm%2FAk0AIkNM68HFAjUZHz1fCTpCcEgWUhRdgXe11tpuuFVBWCubaWJuxgQ1b%2BmrO1631MFiJLQSGlUeKGXq8gh2osSLW55X%2F%2F1Pr%2B%2BtPSeDTW9HM43iI2jiuxHrxY4KiYYIhrQb%2BVT4nRWtDfaWUM3DCjeUIL%2BJ0bOUZf4dflZo15u3tCIsDu2qD7LnvQTs2M%2FJceUr4v4b8%2BBD0Q%2FZv5L1zfQCdJAjoGKVHg73zvlWh19kjZsKBvyceZ91EPeuOKF25Cbm7I8X6F2dTYumtZRE1qsY9GK4HOBbkOaBqyJy9X0xZjDTEowBlA3PoEk1uuNMwB6qHfmcP73okNjxi55t3F%2BfHT3CfI2TgYR2jCN%2FJiXBjqeAf66j2XdKDydHRj2izpKAoe%2FG8SYdaP7oICW5rg9qTHCPDFPwyPRLKgJMZIJZVl%2B5fCTzn6BHglAMWAqb71iXaHpztygP0b0OzkvxVtUD4lf%2BcUAEbPlveCv%2FJxxCodRk1fBEaQ3Z%2B9%2FjaNq%2FnXHzGbceeJJYG%2BljreJp6OBgAQkJvhxo4j65nUkW9rwxrIbSqSlbp3YEGoPJtjAh4Az&X-Amz-Signature=ebda1cfd94dc7ad3210934cbe1ee60a217e6da07577eef9c4999cd974b5293c7"
        },
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
based on the event messages I wrote the python lambda function

```py
import json

def lambda_handler(event, context):
    queueMessges=event['Records'][0]['body']
    print(queueMessges)
    return queueMessges
```
cloudwatch logs

![image](https://user-images.githubusercontent.com/102893121/182020381-bd9b9507-7ba8-4422-bc8b-fc28c6d65df3.png)
