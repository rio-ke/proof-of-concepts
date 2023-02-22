aws-apigateway-authorization-use-iam-role.md

This is the user policy look like

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
}```
