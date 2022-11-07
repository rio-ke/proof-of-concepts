```py
from datadog import initialize, api
from dateutil.tz import tzutc
from datetime import datetime, timedelta
import boto3
import json


def getSecret(secretName, region):
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region
    )
    get_secret_value_response = client.get_secret_value(
        SecretId=secretName
    )
    secretResult = get_secret_value_response['SecretString']
    return secretResult


def datadogMetric(api_key, app_key, region):
    apiKeySecret = getSecret(api_key, region)
    appKeySecret = getSecret(app_key, region)

    options = {
        "api_key": apiKeySecret,
        "app_key": appKeySecret
    }
    initialize(**options)

    title = "SensitiveFileMonitor"
    text = "Sensitive file stay more than 6 hours under specific folder"
    tags = ["env:dev", "application:lambda"]

    return api.Event.create(title=title, text=text, tags=tags)


def findObjectMoreThan6Hours(bucketName):
    s3_resource = boto3.resource('s3')
    listOfObjects = []
    for object in s3_resource.Bucket(bucketName).objects.all():
        if object.last_modified < datetime.now(tzutc()) - timedelta(hours=6):
            listOfObjects.append(object.key)
    if listOfObjects != []:
        return json.dumps({
            "Alert": True,
            "Bucket": bucketName,
            "objectLists": listOfObjects,
            "Action": True
        })
    else:
        return None

# variable section

bucketName = "op-terraform-state-file-1234"
apiKey = "DD_API_KEY"
appKey = "DD_APP_KEY"
region = "us-east-1"


def lambda_handler():
    AlertStatus = findObjectMoreThan6Hours(bucketName)
    if AlertStatus != None:
        print(datadogMetric(apiKey, appKey, region))


```
