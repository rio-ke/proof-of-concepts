
Read the Json from S3

```json
{
  "commonArgs": {
    "--job-language": "python",
    "--enable-metrics": "true",
    "--enable-continuous-cloudwatch-log": "true",
    "--enable-spark-ui": "true",
    "--enable-job-insights": "true",
    "--enable-glue-datacatalog": "true"
  },
  "glueJobsProperty": [
    {
      "poc_Job_DI_Figl_Stg_Intermediate_Load_Stnd": {
        "customArgs": {
          "--TempDir": "s3://s3-bucket-name/tempdir/",
          "--extra-py-files": "s3://s3-bucket-name/dependencies/SQLAlchemy-1.4.28-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl,s3://s3-bucket-name/dependencies/pyutils-3.0.0-py3-none-any.whl,s3://s3-bucket-name/dependencies/psycopg2-2.9.2-cp37-cp37m-linux_x86_64.whl,s3://s3-bucket-name/dependencies/scramp-1.4.0-py3-none-any.whl,s3://s3-bucket-name/dependencies/asn1crypto-1.4.0-py2.py3-none-any.whl,s3://s3-bucket-name/dependencies/awswrangler-2.8.0-py3-none-any.whl,s3://s3-bucket-name/dependencies/pg8000-1.20.0-py3-none-any.whl,s3://s3-bucket-name/dependencies/redshift_connector-2.0.900-py3-none-any.whl",
          "--class": "GlueApp",
          "--job-bookmark-option": "job-bookmark-enable",
          "--spark-event-logs-path": "s3://s3-bucket-name/logs/"
        },
        "Connections": {
          "Connections": ["GlueNetworkConnection"]
        },
        "Timeout": 100,
        "NumberOfWorkers": 2,
        "WorkerType": "G.1X"
      },
      "poc_Job_DI_Figl_Stg_Intermediate_Delta_Load": {
        "customArgs": {
          "--TempDir": "s3://s3-bucket-name/tempdir/",
          "--extra-py-files": "s3://s3-bucket-name/dependencies/SQLAlchemy-1.4.28-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl,s3://s3-bucket-name/dependencies/pyutils-3.0.0-py3-none-any.whl,s3://s3-bucket-name/dependencies/psycopg2-2.9.2-cp37-cp37m-linux_x86_64.whl,s3://s3-bucket-name/dependencies/scramp-1.4.0-py3-none-any.whl,s3://s3-bucket-name/dependencies/asn1crypto-1.4.0-py2.py3-none-any.whl,s3://s3-bucket-name/dependencies/awswrangler-2.8.0-py3-none-any.whl,s3://s3-bucket-name/dependencies/pg8000-1.20.0-py3-none-any.whl,s3://s3-bucket-name/dependencies/redshift_connector-2.0.900-py3-none-any.whl",
          "--class": "GlueApp",
          "--job-bookmark-option": "job-bookmark-enable",
          "--spark-event-logs-path": "s3://s3-bucket-name/logs/"
        },
        "Connections": {
          "Connections": ["GlueNetworkConnection"]
        },
        "Timeout": 20,
        "NumberOfWorkers": 2,
        "WorkerType": "G.1X"
      }
    },
    {
      "poc_Job_DI_Material_Master_Intermediate_Final_Load": {
        "customArgs": {
          "--TempDir": "s3://s3-bucket-name/tempdir",
          "--extra-py-files": "",
          "--additional-python-modules": "xxx",
          "--sfdc_domain": "xxx",
          "--sfdc_endpoint": "xxx",
          "--db_name": "xxx",
          "--bucket": "xxx",
          "--iam": "aws_glue_master",
          "--sfdc_secrets": "xxx",
          "--rs_secret": "xxx",
          "--email_lambda_arn": "xxx",
          "--aws_account": "xxxx",
          "--email_receivers": "xxx"
        }
      },
      "poc_Job_DI_Material_Master_Intermediate_Load": {}
    }
  ]
}

```


```py
import json
import os
import boto3
glueModule = boto3.client('glue')

# GLOBAL VARIABLES
JOBS_PROPERTY_JSON = "metadata.json"


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
    GLUE_ROLE_NAME = os.environ['ROLE_NAME']

    s3 = event['Records'][0]['s3']
    s3Bucket = s3['bucket']
    s3BucketObject = s3['object']
    s3BucketName = s3Bucket['name']  # "poc-t2glue-bucket" #
    s3BucketObjectUrl = s3BucketObject['key']

    sourceS3ScriptLocation = f's3://{s3BucketName}/{s3BucketObjectUrl}'
    splitLocation = s3BucketObjectUrl.split("/")
    originCount = len(splitLocation) - 1
    glueJobName = splitLocation[originCount].removesuffix('.py')
    jsonData = jobObjectJsonProperty(
        s3BucketName, JOBS_PROPERTY_JSON, glueJobName)
    argsData = mergeJsonObjectsList(jsonData, glueJobName)
    Timeout = jsonData['glueJobsProperty'][0][glueJobName]['Timeout']
    Connections = jsonData['glueJobsProperty'][0][glueJobName]['Connections']
    numberOfWorkers = jsonData['glueJobsProperty'][0][glueJobName]['NumberOfWorkers']
    WorkerType = jsonData['glueJobsProperty'][0][glueJobName]['WorkerType']

    try:
        jobStatus = glueModule.get_job(JobName=glueJobName)
        jobDelete = glueModule.delete_job(JobName=glueJobName)
        print("{} has been deleted".format(glueJobName))
    except:
        print("no such previous {} job".format(glueJobName))
    finally:
        createGlueJob = glueModule.create_job(
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

    # GLUEJOB START EXISTING JOBS
    # startCreatedGlueJob = glueModule.start_job_run(
    #     JobName=createGlueJob['Name'],
    #     Arguments={
    #     }
    # )
    # print('startCreatedGlueJob:', startCreatedGlueJob)
    # print('submitting successful job......')
```
