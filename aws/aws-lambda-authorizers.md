
_create a authorizers lambda_

```py
import json

def lambda_handler(event, context):
    auth = "Allow"
    if event['authorizationToken'] == "abc":
        auth = "Allow"
    else:
        auth = "Deny"
    authResponse = ({ "principalId": "abc123", "policyDocument": { "Version": "2012-10-17", "Statement": [{"Action": "execute-api:Invoke", "Resource": ["arn:aws:execute-api:ap-southeast-1:676487226531:1amc9gsy2g/prod/POST/presignedpreurl", "arn:aws:execute-api:ap-southeast-1:676487226531:1amc9gsy2g/prod/POST/presignedpost"], "Effect": auth}] }})
    return authResponse
```

_Use this Lamda from apiGateway_

![image](https://user-images.githubusercontent.com/57703276/204745229-804ed2c0-434a-4147-ba61-1bc2a9a033d9.png)

_invoke the lambda authorizer into a particular method_

![image](https://user-images.githubusercontent.com/57703276/204745521-7ec964f5-33f1-4d94-98e3-9f6d121642cf.png)

_postman_

$$ Failure $$

![image](https://user-images.githubusercontent.com/57703276/204745909-531977b0-4fe4-43c9-a41d-62efcf556c93.png)


$$ Success $$

![image](https://user-images.githubusercontent.com/57703276/204746316-f5b9b4a3-56a4-4865-a0b5-4ca73bfc2f3e.png)
