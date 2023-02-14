
_open api json_

```js
{
  "openapi": "3.0.1",
  "info": {
    "title": "sns-publish-integration-api",
    "description": "sns-publish-integration-api",
    "version": "2023-02-14T07:50:39Z"
  },
  "servers": [
    {
      "url": "",
      "variables": {
        "basePath": {
          "default": "/dev"
        }
      }
    }
  ],
  "paths": {
    "/sqshandler": {
      "post": {
        "parameters": [
          {
            "name": "Action",
            "in": "query",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "Message",
            "in": "query",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "TopicArn",
            "in": "query",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "Subject",
            "in": "query",
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "200 response",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Empty"
                }
              }
            }
          }
        },
        "x-amazon-apigateway-integration": {
          "uri": "arn:aws:apigateway:ap-southeast-1:sns:action/Publish",
          "credentials": "arn:aws:iam::676487226531:role/api-gateway",
          "httpMethod": "POST",
          "responses": {
            "default": {
              "statusCode": "200"
            }
          },
          "requestParameters": {
            "integration.request.querystring.TopicArn": "method.request.querystring.TopicArn",
            "integration.request.querystring.Action": "method.request.querystring.Action",
            "integration.request.querystring.Subject": "method.request.querystring.Subject",
            "integration.request.querystring.Message": "method.request.querystring.Message",
            "integration.request.header.Content-Type": "'application/x-www-form-urlencoded'"
          },
          "requestTemplates": {
            "application/json": "#set($topic='arn:aws:sns:ap-southeast-1:676487226531:eb-sns-test')\r\n#set($msg=$input.body)\r\nAction=Publish&TopicArn=$util.urlEncode($topic)&Message=$util.urlEncode($msg)"
          },
          "passthroughBehavior": "never",
          "type": "aws"
        }
      }
    }
  },
  "components": {
    "schemas": {
      "Empty": {
        "title": "Empty Schema",
        "type": "object"
      }
    }
  },
  "x-amazon-apigateway-binary-media-types": [
    "application/x-www-form-urlencoded"
  ]
}

```

_any type of json object post integration_

```json
{
    "openapi" : "3.0.1",
    "info" : {
      "title" : "gino",
      "description" : "Presigned url",
      "version" : "2023-02-14T07:50:39Z"
    },
    "servers" : [],
    "paths" : {
      "/sqshandler" : {
        "post" : {
          "responses" : {
            "200" : {
              "description" : "200 response",
              "content" : {
                "application/json" : {
                  "schema" : {
                    "$ref" : "#/components/schemas/Empty"
                  }
                }
              }
            }
          },
          "x-amazon-apigateway-integration" : {
            "type" : "aws",
            "uri" : "arn:aws:apigateway:ap-southeast-1:sns:action/Publish",
            "credentials" : "arn:aws:iam::676487226531:role/api-gateway",
            "httpMethod" : "POST",
            "responses" : {
              "default" : {
                "statusCode" : "200"
              }
            },
            "requestParameters" : {
              "integration.request.header.Content-Type" : "'application/x-www-form-urlencoded'"
            },
            "requestTemplates" : {
              "application/json" : "#set($topic='arn:aws:sns:ap-southeast-1:676487226531:eb-sns-test')\r\n#set($msg=$input.body)\r\nAction=Publish&TopicArn=$util.urlEncode($topic)&Message=$util.urlEncode($msg)"
            },
            "passthroughBehavior" : "never"
          }
        }
      }
    },
    "components" : {
      "schemas" : {
        "Empty" : {
          "title" : "Empty Schema",
          "type" : "object"
        }
      }
    },
    "x-amazon-apigateway-binary-media-types" : [ "application/x-www-form-urlencoded" ]
  }
```

_Request body_

```js
{
    "name": "demo",
    "message": "first message"
}
```
