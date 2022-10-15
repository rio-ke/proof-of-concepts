**_Get the values from json object_**
```py
#!/usr/bin/env python3
import json
data = {
    "Records": [
        {
            "eventVersion": "2.1",
            "eventSource": "aws:s3",
            "awsRegion": "ap-southeast-1",
            "eventTime": "2022-07-31T06:54:20.293Z",
            "eventName": "ObjectCreated:Put",
            "userIdentity": {"principalId": "A3H9EVE2DDNAB9"},
            "requestParameters": {"sourceIPAddress": "49.204.113.169"},
            "responseElements": {
                "x-amz-request-id": "19M5DNJ0952B8HJY",
                "x-amz-id-2": "b93R+PNOtzjViMz5mxq8W1ejFIKcjjRmlBDpvRfHhzxE6NJJm1jOV36cJUkI7fcLNARrPiSsofkQ7xHIR2Q4hSGb6JO9IcBH"
            },
            "s3": {
                "s3SchemaVersion": "1.0",
                "configurationId": "pre-sign-url",
                "bucket": {
                    "name": "pre-signed-url-local",
                    "ownerIdentity": {"principalId": "A3H9EVE2DDNAB9"},
                    "arn": "arn:aws:s3:::pre-signed-url-local"
                },
                "object": {
                    "key": "job-one.py",
                    "size": 205,
                    "eTag": "b5cfdce177d589dd39243adf1cec46e7",
                    "sequencer": "0062E6271C43DE0B18"
                }
            }
        }
    ]
}


def main(event):
     checkAttribute = 'Records' in event.keys()
     if checkAttribute == True:
         return event["Records"][0]["s3"]
     else:
         return False

print(main(data))
```
**_Get the values from json object - one file to another file_**

filename -input.json
```py
{
  "Records": [
    {
      "eventVersion": "2.1",
      "eventSource": "aws:s3",
      "awsRegion": "ap-southeast-1",
      "eventTime": "2022-07-31T06:54:20.293Z",
      "eventName": "ObjectCreated:Put",
      "userIdentity": { "principalId": "A3H9EVE2DDNAB9" },
      "requestParameters": { "sourceIPAddress": "49.204.113.169" },
      "responseElements": {
        "x-amz-request-id": "19M5DNJ0952B8HJY",
        "x-amz-id-2": "b93R+PNOtzjViMz5mxq8W1ejFIKcjjRmlBDpvRfHhzxE6NJJm1jOV36cJUkI7fcLNARrPiSsofkQ7xHIR2Q4hSGb6JO9IcBH"
      },
      "s3": {
        "s3SchemaVersion": "1.0",
        "configurationId": "pre-sign-url",
        "bucket": {
          "name": "pre-signed-url-local",
          "ownerIdentity": { "principalId": "A3H9EVE2DDNAB9" },
          "arn": "arn:aws:s3:::pre-signed-url-local"
        },
        "object": {
          "key": "job-one.py",
          "size": 205,
          "eTag": "b5cfdce177d589dd39243adf1cec46e7",
          "sequencer": "0062E6271C43DE0B18"
        }
      }
    }
  ]
}

```
filename - demo.py
```py
#!/usr/bin/env python3
import json
with open("input.json") as json_file:
       getJsonData = json.load(json_file)

def jsonAttribute(event):
    test2 = 'Records' in event.keys()
    if test2 == True:
        return event["Records"][0]["s3"]
    else:
        return "values not match"
```
