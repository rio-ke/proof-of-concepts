```py
import json
import os
import boto3
glueClient = boto3.client('glue')

# GLOBAL VARIABLES
JOBS_PROPERTY_JSON = "metadata-qa.json"
BUCKET_NAME = os.environ['BUCKET_NAME']
GLUE_ROLE_NAME = os.environ['ROLE_NAME']


def jobObjectJsonProperty(bucket, filename):
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


def searchJob(list, jobname):
    for i in range(len(list)):
        if list[i] == jobname:
            return True
    return False


def getJobDetails():
    jobStatus = glueClient.list_jobs(MaxResults=1000)
    return jobStatus['JobNames']

# Start Point


def lambda_handler(event, context):
    jsonData = jobObjectJsonProperty(BUCKET_NAME, JOBS_PROPERTY_JSON)
    status = jsonData['glueJobsProperty'][0]

    for keyname, value in status.items():
        GLUEJOB_NAME = keyname
        deploymentStatus = jsonData['glueJobsProperty'][0][GLUEJOB_NAME]['deploymentStatus']

        if deploymentStatus == "true":
            sourceS3ScriptLocation = f's3://{BUCKET_NAME}/source/{GLUEJOB_NAME}.py'
            argsData = mergeJsonObjectsList(jsonData, GLUEJOB_NAME)
            Timeout = jsonData['glueJobsProperty'][0][GLUEJOB_NAME]['Timeout']
            #Connections = jsonData['glueJobsProperty'][0][GLUEJOB_NAME]['Connections']
            numberOfWorkers = jsonData['glueJobsProperty'][0][GLUEJOB_NAME]['NumberOfWorkers']
            WorkerType = jsonData['glueJobsProperty'][0][GLUEJOB_NAME]['WorkerType']
            MaxConcurrentRuns = jsonData['glueJobsProperty'][0][GLUEJOB_NAME]['MaxConcurrentRuns']

            list = getJobDetails()
            if searchJob(list, GLUEJOB_NAME):
                glueClient.delete_job(JobName=GLUEJOB_NAME)
                print("{} has been deleted".format(GLUEJOB_NAME))
                glueClient.create_job(
                    Name=GLUEJOB_NAME,
                    Role=GLUE_ROLE_NAME,
                    ExecutionProperty={
                        'MaxConcurrentRuns': MaxConcurrentRuns
                    },
                    Command={
                        'Name': 'glueetl',
                        'ScriptLocation': sourceS3ScriptLocation
                    },
                    DefaultArguments=argsData,
                    GlueVersion='3.0',
                    Timeout=Timeout,
                    # Connections=Connections,
                    NumberOfWorkers=numberOfWorkers,
                    WorkerType=WorkerType
                )
                print("{} has been created".format(GLUEJOB_NAME))
            else:
                glueClient.create_job(
                    Name=GLUEJOB_NAME,
                    Role=GLUE_ROLE_NAME,
                    ExecutionProperty={
                        'MaxConcurrentRuns': MaxConcurrentRuns
                    },
                    Command={
                        'Name': 'glueetl',
                        'ScriptLocation': sourceS3ScriptLocation
                    },
                    DefaultArguments=argsData,
                    GlueVersion='3.0',
                    Timeout=Timeout,
                    # Connections=Connections,
                    NumberOfWorkers=numberOfWorkers,
                    WorkerType=WorkerType
                )
                print("{} has been created".format(GLUEJOB_NAME))
        # else:
        #     return {
        #         "status": "no jobs avaible to deployment",
        #         "statusCOde": 200
        #     }

    return {
        "status": "deploymentCompleted",
        "statusCOde": 201
    }

```
