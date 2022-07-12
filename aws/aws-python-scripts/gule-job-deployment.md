```python3
import boto3

# s3Resource = boto3.resource("s3")
glue = boto3.client('glue')
s3 = boto3.client("s3")


def uploadS3File(Filename, Bucket, Key):
    s3.upload_file(Filename, Bucket, Key)
    return "s3://" + Bucket + "/" + Key


def createGlueJob(glueJobName="gino", glueIamRole="glue-job-role"):
    s3_script_path = uploadS3File(Filename="print.py",
                                  Bucket="dodo-dev-s3",
                                  Key="scripts/print.py")


# s3: // dodo-dev-s3/scripts/print.py
    response = glue.create_job(
        Name=glueJobName,
        Description='Data Preparation Job for model training',
        Role=glueIamRole,
        MaxRetries=1,
        Timeout=1440,
        GlueVersion='1.0',
        NumberOfWorkers=1,
        WorkerType='Standard',
        ExecutionProperty={
            'MaxConcurrentRuns': 1
        },
        Command={
            'Name': 'glueetl',
            'ScriptLocation': s3_script_path,
            'PythonVersion': '3'
        },
        Tags={
            'usecase': 'ml-workflow-preprocessing'
        }
    )
    return response


print(createGlueJob())

# https://boto3.amazonaws.com/v1/documentation/api/1.9.185/reference/services/ssm.html
# https://gist.github.com/oelesinsc24/bb6aa4965fd83ef0f9a6faf912d71476
# https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-jobs-job.html#aws-glue-api-jobs-job-JobCommand


```
