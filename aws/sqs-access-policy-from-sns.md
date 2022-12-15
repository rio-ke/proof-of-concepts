
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
      "Resource": "arn:aws:sqs:ap-southeast-1:676487226531:eb-sqs-test",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:sns:ap-southeast-1:676487226531:eb-sns-test"
        }
      }
    }
  ]
}
```
