#!/usr/bin/env python3

# instance-information-use-ssm.py
import boto3
client = boto3.client('ssm', region_name="ap-south-1")

def instanceSessionDataInformations():
    data = client.describe_instance_information()
    return data['InstanceInformationList']

def printInstanceSessionDataInformations():
    data = instanceSessionDataInformations()
    if data != []:
        for instance in data:
            print(instance['PlatformName'], instance['PlatformVersion'])
    else:
        print("There is no instance associated with ssm manager.")

printInstanceSessionDataInformations()
