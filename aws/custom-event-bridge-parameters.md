

_sample json_

```js
{
	"version": "0",
	"id": "89ae6ed7-b7d0-da62-e1e3-c2a7ca679e3a",
	"detail-type": "AWS API Call via CloudTrail",
	"source": "aws.s3",
	"account": "676487226531",
	"time": "2022-12-15T07:26:24Z",
	"region": "ap-southeast-1",
	"resources": [],
	"detail": {
		"eventVersion": "1.08",
		"userIdentity": {
			"type": "Root",
			"principalId": "676487226531",
			"arn": "arn:aws:iam::676487226531:root",
			"accountId": "676487226531",
			"accessKeyId": "ASIAZ3AOH4SR32UQRAQL",
			"sessionContext": {
				"attributes": {
					"creationDate": "2022-12-15T05:23:13Z",
					"mfaAuthenticated": "false"
				}
			}
		},
		"eventTime": "2022-12-15T07:26:24Z",
		"eventSource": "s3.amazonaws.com",
		"eventName": "PutObject",
		"awsRegion": "ap-southeast-1",
		"sourceIPAddress": "165.225.112.92",
		"userAgent": "[Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36]",
		"requestParameters": {
			"X-Amz-Date": "20221215T072623Z",
			"bucketName": "sftp-a1-bucket",
			"X-Amz-Algorithm": "AWS4-HMAC-SHA256",
			"x-amz-acl": "bucket-owner-full-control",
			"X-Amz-SignedHeaders": "content-md5;content-type;host;x-amz-acl;x-amz-storage-class",
			"Host": "sftp-a1-bucket.s3.ap-southeast-1.amazonaws.com",
			"X-Amz-Expires": "300",
			"key": "A_C/ip/cnxcp/t3/sftp_event_notification.txt",
			"x-amz-storage-class": "STANDARD"
		},
		"responseElements": None,
		"additionalEventData": {
			"SignatureVersion": "SigV4",
			"CipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
			"bytesTransferredIn": 1462.0,
			"AuthenticationMethod": "QueryString",
			"x-amz-id-2": "CuRHpORpA8c4/Hcgkq0ffVn1eHTNW4mUUg0DW6RaVrUqYgfT7gFCKJQkuFAMhPpGWDClmL2+eWY=",
			"bytesTransferredOut": 0.0
		},
		"requestID": "FDHQAXYKY6WYCV3M",
		"eventID": "00112675-1ca3-41d6-8908-b62ba7571b03",
		"readOnly": False,
		"resources": [{
			"type": "AWS::S3::Object",
			"ARN": "arn:aws:s3:::sftp-a1-bucket/A_C/ip/cnxcp/t3/sftp_event_notification.txt"
		}, {
			"accountId": "676487226531",
			"type": "AWS::S3::Bucket",
			"ARN": "arn:aws:s3:::sftp-a1-bucket"
		}],
		"eventType": "AwsApiCall",
		"managementEvent": False,
		"recipientAccountId": "676487226531",
		"eventCategory": "Data",
		"tlsDetails": {
			"tlsVersion": "TLSv1.2",
			"cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
			"clientProvidedHostHeader": "sftp-a1-bucket.s3.ap-southeast-1.amazonaws.com"
		}
	}
}

```

_input transform_


```js
{"bucket":"$.detail.requestParameters.bucketName","eventTime":"$.detail.eventTime","key":"$.detail.requestParameters.key","version":"$.detail.eventVersion"}
```


_output transformer_

```js
{
  "Source": <bucket>,
  "Event": "file-created",
  "eventTime": <eventTime>,
  "Object": {
    "Key": <key>,
    "Version": <version>
  },
  "EventDetail": {
    "status": "ok"
  }
}

```
