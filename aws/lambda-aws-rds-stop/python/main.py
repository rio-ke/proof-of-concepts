import boto3
import os

region = os.environ['region']
tagname = os.environ['tagname']
tagvalue = os.environ['tagvalue']

def lambda_handler(event, context):
    rds = boto3.client('rds', region_name=region)
    instances = rds.describe_db_instances()['DBInstances']
    rdsInstances = []
    if instances:
        for i in instances:
            if (i['DBInstanceStatus']) == 'available':
                arn = i['DBInstanceArn']
                RDSInstance = i['DBInstanceIdentifier']
                tags = rds.list_tags_for_resource(ResourceName=arn)['TagList']
                for tag in tags:
                    if tag["Value"] == tagvalue:
                        rdsInstances.append(RDSInstance)

    if rdsInstances != []:
        for i in rdsInstances:
            rds.stop_db_instance(DBInstanceIdentifier=i)
            print('stopped your RDS instances: ' + str(i))