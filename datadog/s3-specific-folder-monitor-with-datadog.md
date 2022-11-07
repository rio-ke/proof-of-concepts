

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


def findObjectMoreThan6HoursIsightFolder(bucketName, folderName):
    s3_resource = boto3.resource('s3')
    Bucket = s3_resource.Bucket(bucketName)

    listOfDirectoryObjects = []
    for object in Bucket.objects.filter(Prefix=folderName + "/"):
        SkipDirectory = folderName + "/"
        if object.key != SkipDirectory:
            if object.last_modified < datetime.now(tzutc()) - timedelta(hours=6):
                listOfDirectoryObjects.append(object.key)

    if listOfDirectoryObjects != []:
        return json.dumps({
            "Alert": True,
            "Bucket": bucketName,
            "folderName": folderName,
            "Action": True
        })
    else:
        return None


# variable section

bucketName = "op-terraform-state-file-1234"
folderName = "demo"
apiKey = "DD_API_KEY"
appKey = "DD_APP_KEY"
region = "us-east-1"


def lambda_handler():
    AlertStatus = findObjectMoreThan6HoursIsightFolder(bucketName, folderName)
    if AlertStatus != None:
        print(datadogMetric(apiKey, appKey, region))

```
