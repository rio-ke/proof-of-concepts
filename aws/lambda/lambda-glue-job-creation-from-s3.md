
Read the Json from S3

```json
{
  "commonArgs": {
    "--job-language": "python",
    "--enable-metrics": true,
    "--enable-continuous-cloudwatch-log": true,
    "--enable-spark-ui": true
  },
  "glueJobsProperty": [
    {
      "poc_Job_DI_Material_Master_Intermediate_Final_Load": {
        "customArgs": {
          "--TempDir": "s3://${BuildBucket}/tempdir",
          "--extra-py-files": "xxx",
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
        },
        "name": "joe",
        "email": "lokesh@mail.com"
      },
      "poc_Job_DI_Material_Master_Intermediate_Load": {},
      "jobTwo": {
        "name": "joe",
        "email": "lokesh@mail.com",
        "age": 10,
        "mobile": 9894586
      }
    }
  ]
}
```


```py
import os
import boto3
glueModule = boto3.client('glue')
import json


# GLOBAL VERIABLES
JOBS_PROPERTY_JSON="glueJobsProperty.json"


def jobObjectJsonProperty(bucket, filename, jobname):
    s3 = boto3.resource('s3')
    content_object = s3.Object(bucket, filename)
    file_content = content_object.get()['Body'].read().decode('utf-8')
    json_content = json.loads(file_content)
    return json_content['glueJobsProperty'][0][jobname]

# Merge Json Object
def mergeJsonObjectsList(fileObjectData, jobName):
    commonArgs=fileObjectData['commonArgs']
    defaultArgs=fileObjectData['glueJobsProperty'][0][jobName]['customArgs']
    mergeJsonObjectsList = [commonArgs, defaultArgs]
    mergeJson=({i:j for x in mergeJsonObjectsList for i,j in x.items()})
    return mergeJson


# EXECUTION STARING POINT
def lambda_handler(event, context):

    GLUE_ROLE_NAME = "aws_glue_master" # os.environ['ROLE_NAME']

    # print(event)
    s3 = event['Records'][0]['s3']
    s3Bucket = s3['bucket']
    s3BucketObject = s3['object']
    s3BucketName = s3Bucket['name']
    s3BucketObjectUrl = s3BucketObject['key']

    
    sourceS3ScriptLocation = f's3://{s3BucketName}/{s3BucketObjectUrl}'

    splitLocation = s3BucketObjectUrl.split("/")
    originCount = splitLocation._len_() - 1
    
    glueJobName = splitLocation[originCount].removesuffix('.py')
    # print(splitLocation[originCount])
    # fileName=splitLocation[originCount]
    # split_tup = os.path.splitext(fileName)
    # print(split_tup[1])
 

    # fileObjectProperty = jobObjectJsonProperty(s3BucketName, JOBS_PROPERTY_JSON, glueJobName)
    # print(fileObjectProperty)

    # GLUEJOB EXPECTED JSON ARGUMENTS

    default_arguments = mergeJsonObjectsList(jobObjectJsonProperty(s3BucketName, JOBS_PROPERTY_JSON, glueJobName), glueJobName)
    print(default_arguments)

    # createGlueJob = glueModule.create_job(
    #     Name=glueJobName,
    #     Role=GLUE_ROLE_NAME,
    #     Command={
    #         'Name': 'glueetl',
    #         'ScriptLocation': sourceS3ScriptLocation
    #     },
    #     DefaultArguments=default_arguments,
    #     GlueVersion='2.0'
    # )
    # print('createGlueJob:', createGlueJob)

    # GLUEJOB START EXISTING JOBS
    # startCreatedGlueJob = glueModule.start_job_run(
    #     JobName=createGlueJob['Name'],
    #     Arguments={
    #     }
    # )
    # print('startCreatedGlueJob:', startCreatedGlueJob)
    # print('submitting successful job......')
```
