

```json
{
	"version": "0",
	"id": "147ac923-d3ec-aa30-469e-04cd83e4874b",
	"detail-type": "AWS API Call via CloudTrail",
	"source": "aws.s3",
	"account": "676487226531",
	"time": "2022-11-13T07:10:21Z",
	"region": "ap-southeast-1",
	"resources": [],
	"detail": {
		"eventVersion": "1.08",
		"userIdentity": {
			"type": "Root",
			"principalId": "676487226531",
			"arn": "arn:aws:iam::676487226531:root",
			"accountId": "676487226531",
			"accessKeyId": "ASIAZ3AOH4SRVIQERPNO",
			"sessionContext": {
				"attributes": {
					"creationDate": "2022-11-13T06:51:36Z",
					"mfaAuthenticated": "false"
				}
			}
		},
		"eventTime": "2022-11-13T07:10:21Z",
		"eventSource": "s3.amazonaws.com",
		"eventName": "PutObject",
		"awsRegion": "ap-southeast-1",
		"sourceIPAddress": "136.226.254.191",
		"userAgent": "[Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 Edg/107.0.1418.35]",
		"requestParameters": {
			"X-Amz-Date": "20221113T071018Z",
			"bucketName": "jn-logs-s3",
			"X-Amz-Algorithm": "AWS4-HMAC-SHA256",
			"x-amz-acl": "bucket-owner-full-control",
			"X-Amz-SignedHeaders": "content-md5;content-type;host;x-amz-acl;x-amz-storage-class",
			"Host": "jn-logs-s3.s3.ap-southeast-1.amazonaws.com",
			"X-Amz-Expires": "300",
			"key": "bash.sh",
			"x-amz-storage-class": "STANDARD"
		},
		"responseElements": None,
		"additionalEventData": {
			"SignatureVersion": "SigV4",
			"CipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
			"bytesTransferredIn": 2538.0,
			"AuthenticationMethod": "QueryString",
			"x-amz-id-2": "eLHzlmSLH7umQ27kNCHNnkqk12X7zYMvAbjZ8GPirEr05FexzKzHSFicGmSQjX8qiGEcYqDGYLs=",
			"bytesTransferredOut": 0.0
		},
		"requestID": "91M74KC7AZD4A6VC",
		"eventID": "ecf02e1b-2332-4e04-8e8b-749d8b7a7743",
		"readOnly": False,
		"resources": [{
			"type": "AWS::S3::Object",
			"ARN": "arn:aws:s3:::jn-logs-s3/bash.sh"
		}, {
			"accountId": "676487226531",
			"type": "AWS::S3::Bucket",
			"ARN": "arn:aws:s3:::jn-logs-s3"
		}],
		"eventType": "AwsApiCall",
		"managementEvent": False,
		"recipientAccountId": "676487226531",
		"eventCategory": "Data",
		"tlsDetails": {
			"tlsVersion": "TLSv1.2",
			"cipherSuite": "ECDHE-RSA-AES128-GCM-SHA256",
			"clientProvidedHostHeader": "jn-logs-s3.s3.ap-southeast-1.amazonaws.com"
		}
	}
}
```
