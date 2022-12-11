**_sqs-message-post-from-apigateway.md_**

_send an body as a message_

```js
Action=SendMessage&MessageBody=$input.body
```
_detailed message_

```js
Action=SendMessage&MessageBody={
  "bodyJson": $input.json('$'),
  "bodyRaw": "$util.escapeJavaScript($input.body)",
  "requestId": "$context.requestId",
  "resourcePath": "$context.resourcePath",
  "apiId": "$context.apiId",
  "stage": "$context.stage",
  "resourceId": "$context.resourceId",
  "path": "$context.path",
  "protocol": "$context.protocol",
  "requestTimeEpoch": "$context.requestTimeEpoch",
  #set($allParams = $input.params())
  "params" : {
    #foreach($type in $allParams.keySet())
    #set($params = $allParams.get($type))
    "$type" : {
      #foreach($paramName in $params.keySet())
      "$paramName" : "$util.escapeJavaScript($params.get($paramName))"
      #if($foreach.hasNext),#end
      #end
    }
    #if($foreach.hasNext),#end
    #end
  }
}
```
