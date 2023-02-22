_aws-apigateway-authorization-use-iam-role_

aws IAM ROLE authentication should be enabled like this.

![image](https://user-images.githubusercontent.com/57703276/220544675-9232f6c9-deb9-4103-90a3-d8a4d0e72132.png)

apigateway should be configure like this

![image](https://user-images.githubusercontent.com/57703276/220544832-e8caa984-443a-48fb-863f-adf8b1930d62.png)



create the user and attach it to a group. The following policy should be attached at the group level.

```js
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["execute-api:Invoke"],
      "Resource": [
        "arn:aws:execute-api:ap-southeast-1:xx509645xx:32coyoyvb5/*/GET/bds"
      ]
    },
    {
      "Effect": "Deny",
      "Action": ["execute-api:Invoke"],
      "Resource": [
        "arn:aws:execute-api:ap-southeast-1:xx509645xx:32coyoyvb5/*/GET/gino"
      ]
    }
  ]
}
```

finally you should scrap the acces key and secret key from the user security credentials.

_success message_

![image](https://user-images.githubusercontent.com/57703276/220546560-7df683e7-ef23-45e0-8627-95e85390258f.png)

_deny message_

![image](https://user-images.githubusercontent.com/57703276/220546452-57f89b5d-a117-4699-942f-c19e83bd4670.png)


