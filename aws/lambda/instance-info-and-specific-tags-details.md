## lambda-instance-info-and-specific-tags-details.md

```py
import boto3
import os

REGION_NAME = "ap-south-1"

def lambda_handler(event, context):
    if (event['Test'] == "True"):
        print("instance tags information")
        instanceTagFinds()
        print("")
        print("system information")
        runingInstanceInformation()
    else:
        print("skipped based on test conditions")
        
def instanceTagFinds():
    ec2 = boto3.client('ec2', region_name=REGION_NAME)
    response = ec2.describe_instances()
    for reservation in (response["Reservations"]):
        for instance in reservation["Instances"]:
            output_dict = [x for x in instance['Tags'] if x['Key'] == 'Service' or x['Key'] == 'service']
            if (len(output_dict) == 0):
                print(instance["InstanceId"], "no tags found")
            else:
                print(instance["InstanceId"], output_dict[0]['Value'])

def runingInstanceInformation():
    ec2_client = boto3.client("ec2", region_name=REGION_NAME)
    reservations = ec2_client.describe_instances(Filters=[
        {
            "Name": "instance-state-name",
            "Values": ["running"],
        }
    ])
    for reservation in (reservations["Reservations"]):
        for instance in reservation["Instances"]:
            print("instance_id: {}, instance_type: {}, public_ip: {}, private_ip: {}".format(instance["InstanceId"], instance["InstanceType"], instance["PublicIpAddress"], instance["PrivateIpAddress"]))
```
