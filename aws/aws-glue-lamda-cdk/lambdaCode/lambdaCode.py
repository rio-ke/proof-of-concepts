import os
import boto3
glueModule = boto3.client('glue')


def lambda_handler(event, context):

    # RNVIRONMENT VARIBALE READ

    GLUE_ROLE_NAME = os.environ['ROLE_NAME']

    # print(event)
    job = event['Records']
    data = job[0]
    s3 = data['s3']
    # s3 = event['Records'][0]['s3']
    s3Bucket = s3['bucket']
    s3BucketObject = s3['object']
    s3BucketName = s3Bucket['name']
    s3BucketObjectUrl = s3BucketObject['key']

    sourceS3ScriptLocation = f's3://{s3BucketName}/{s3BucketObjectUrl}'

    splitLocation = s3BucketObjectUrl.split("/")
    originCount = splitLocation.__len__() - 1
    glueJobName = splitLocation[originCount].removesuffix('.py')

    # GLUEJOB CREATE ARGUMENTS
    default_arguments = {}

    createGlueJob = glueModule.create_job(
        Name=glueJobName,
        Role=GLUE_ROLE_NAME,
        Command={
            'Name': 'glueetl',
            'ScriptLocation': sourceS3ScriptLocation
        },
        DefaultArguments=default_arguments,
        GlueVersion='2.0'
    )
    print('createGlueJob:', createGlueJob)

    # GLUEJOB START EXISTING JOBS

    startCreatedGlueJob = glueModule.start_job_run(
        JobName=createGlueJob['Name'],
        Arguments={
        }
    )
    print('startCreatedGlueJob:', startCreatedGlueJob)
    print('submitting successful job......')
