import json
import os
import boto3
glueModule = boto3.client('glue')

# GLOBAL VARIABLES
ENVIRONMENT_NAME=os.environ['ENVIRONMENT_NAME']
JOBS_PROPERTY_JSON = "metadata" + "-" + ENVIRONMENT_NAME + ".json"

# Read the metadata from S3
def jobObjectJsonProperty(bucket, filename, jobname):
    s3 = boto3.resource('s3')
    content_object = s3.Object(bucket, filename)
    file_content = content_object.get()['Body'].read().decode('utf-8')
    json_content = json.loads(file_content)
    return json_content

# Merge Json Object
def mergeJsonObjectsList(fileObjectData, jobName):
    commonArgs = fileObjectData['commonArgs']
    defaultArgs = fileObjectData['glueJobsProperty'][0][jobName]['customArgs']
    mergeJsonObjectsList = [commonArgs, defaultArgs]
    mergeJson = ({i: j for x in mergeJsonObjectsList for i, j in x.items()})
    return mergeJson

# EXECUTION STARING POINT
def lambda_handler(event, context):
    s3 = event['Records'][0]['s3']
    s3Bucket = s3['bucket']
    s3BucketObject = s3['object']
    s3BucketName = s3Bucket['name']
    s3BucketObjectUrl = s3BucketObject['key']

    sourceS3ScriptLocation = f's3://{s3BucketName}/{s3BucketObjectUrl}'
    splitLocation = s3BucketObjectUrl.split("/")
    originCount = len(splitLocation) - 1
    glueJobName = splitLocation[originCount].removesuffix('.py')
    jsonData = jobObjectJsonProperty(s3BucketName, JOBS_PROPERTY_JSON, glueJobName)
    argsData = mergeJsonObjectsList(jsonData, glueJobName)
    Timeout = jsonData['glueJobsProperty'][0][glueJobName]['Timeout']
    Connections = jsonData['glueJobsProperty'][0][glueJobName]['Connections']
    numberOfWorkers = jsonData['glueJobsProperty'][0][glueJobName]['NumberOfWorkers']
    WorkerType = jsonData['glueJobsProperty'][0][glueJobName]['WorkerType']
    GLUE_ROLE_NAME = jsonData['glueJobsProperty'][0][glueJobName]['roleName']
    try:
        glueModule.get_job(JobName=glueJobName)
        glueModule.delete_job(JobName=glueJobName)
        print("{} has been deleted".format(glueJobName))
    except:
        print("no such previous {} job".format(glueJobName))
    finally:
        glueModule.create_job(
            Name=glueJobName,
            Role=GLUE_ROLE_NAME,
            Command={
                'Name': 'glueetl',
                'ScriptLocation': sourceS3ScriptLocation
            },
            DefaultArguments=argsData,
            GlueVersion='3.0',
            Timeout=Timeout,
            Connections=Connections,
            NumberOfWorkers=numberOfWorkers,
            WorkerType=WorkerType,
        )
        print("{} has been created".format(glueJobName))