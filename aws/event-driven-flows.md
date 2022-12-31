_common bucket_

dodo-secret-common

_internet bucket_

`upload - dodo-upload-internet`

```json
{
    "path": "A-B",
    "event": "putObject",
    "eventRule": "dodo-upload-internet-a2b-direction-rule",
    "actioner": "lambda",
    "process": "copy to scan and safe internet buckets"
}
```

`scan - dodo-scan-internet`
    
```json
{
    "path": "*",
    "event": "tagging",
    "eventRule": "dodo-scan-internet-tagging-direction-rule",
    "actioner": "lambda",
    "process": "find as internet or internet tag forward to appropriate location"
}
```

`safe - dodo-safe-internet`

```json
[
    {
        "path": "*",
        "event": "tagging",
        "eventRule": "dodo-scan-internet-tagging-direction-rule",
        "actioner": "lambda",
        "process": "find as internet or internet tag forward to appropriate location"
    },
    {
        "path": "*",
        "event": "putObject",
        "eventRule": "dodo-safe-internet-b2c-direction-rule",
        "actioner": "lambda",
        "process": "find as internet or internet tag forward to appropriate location"
    }
]
```

sftp - dodo-sftp-internet

_dodo-sftp-internet-in-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-sftp-internet"],
      "key": [{
        "prefix": "SFTP/IN"
      }]
    }
  }
}
```
quarantined - dodo-quarantined-internet

`lambda - dodo-lambda-internet`


```py
print("lambda")
```

_event rule_

_dodo-upload-internet-a2b-direction-rule_
```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-upload-internet"],
      "key": [{
        "prefix": "A_B"
      }]
    }
  }
}
```
_dodo-scan-internet-tagging-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObjectTagging"],
    "requestParameters": {
      "bucketName": ["dodo-scan-internet"]
    }
  }
}
```

_dodo-safe-internet-tagging-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObjectTagging"],
    "requestParameters": {
      "bucketName": ["dodo-safe-internet"]
    }
  }
}
```

_dodo-safe-internet-b2c-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-safe-internet"],
      "key": [{
        "prefix": "B_C"
      }]
    }
  }
}

```

_intranet_


`upload - dodo-upload-intranet`

```json
{
    "path": "t2",
    "event": "putObject",
    "eventRule": "dodo-upload-intranet-t2-direction-rule",
    "actioner": "lambda",
    "process": "dodo-safe-intranet, dodo-scan-internet, deletion"
}
```

`safe - dodo-safe-intranet`

```json
{
    "path": "C_BA",
    "event": "putObject",
    "eventRule": "dodo-safe-intranet-c2ba-direction-rule",
    "actioner": "lambda",
    "process": "dodo-safe-internet, dodo-upload-internet, no deletion process"
}
```


`sftp - dodo-sftp-intranet` 

```json
{
    "path": "D_C",
    "event": "putObject",
    "eventRule": "dodo-sftp-intranet-d2c-direction-rule",
    "actioner": "lambda",
    "process": "dodo-safe-intranet, dodo-scan-internet, deletion"
}
```

final - dodo-final-intranet
quarantined - dodo-quarantined-intranet


`lambda - dodo-lambda-intranet`

```py
print("lambda")
```

_intranet event rule_

_dodo-upload-intranet-t2-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-upload-intranet"],
      "key": [{
        "prefix": "t2"
      }]
    }
  }
}

```

_dodo-safe-intranet-c2ba-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-safe-intranet"],
      "key": [{
        "prefix": "C_BA"
      }]
    }
  }
}
```

_dodo-sftp-intranet-d2c-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-sftp-intranet"],
      "key": [{
        "prefix": "D_C"
      }]
    }
  }
}
```



_pub-sub flows_

event bus - dodo-pub-sub-event-bus
event-rule - dodo-pub-sub-event-rule

_dodo-pub-sub-event-rule_

```json
{
   "source": ["custom.consumer"],
   "detail-type": ["notification"]
}
```
sns - dodo-sns-publisher-subriber
sqs - dodo-sns-publisher-subriber
lambda - dodo-lambda-publisher-subriber



SFTP/IN/ip/A_B
