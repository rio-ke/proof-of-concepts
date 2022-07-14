## instance-information-use-ssm.md

**_depencencies_**

* aws configure
* python3
* boto3

**_scripts_**


**_senario 1_**

```python3
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
            for i, j in instance.items():
                if i != "AssociationOverview" and i != "LastSuccessfulAssociationExecutionDate":
                    print(i.ljust(35), "-", j)
            print("")
    else:
        print("There is no instance associated with ssm manager.")

printInstanceSessionDataInformations()

```

**_senario 2_**

```python3
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
            for i, j in instance.items():
                if i == "PlatformName" or i == "PlatformVersion":
                    print(i.ljust(35), "-", j)
            print("")
    else:
        print("There is no instance associated with ssm manager.")

printInstanceSessionDataInformations()
```

_script 3_

```python3
#!/usr/bin/env python3

# instance-information-use-ssm.py

import boto3
session = boto3.Session(profile_name='dev')

client = session.client('ssm', region_name="ap-south-1")

def instanceSessionDataInformations():
    data = client.describe_instance_information()
    return data['InstanceInformationList']

def printInstanceSessionDataInformations():
    data = instanceSessionDataInformations()
    if data != []:
        for instance in data:
            print(instance['InstanceId'], instance['PlatformName'], instance['PlatformVersion'])
    else:
        print("There is no instance associated with ssm manager.")

printInstanceSessionDataInformations()

```
_script 4_

```python3
#!/usr/bin/env python3
import boto3

# instance-information-use-ssm.py

session = boto3.Session(profile_name='dev')
ins = session.client('ec2', region_name="ap-south-1")
ssm = session.client('ssm', region_name="ap-south-1")

def findEc2InstanceName(id):
    ec2 = ins.describe_instances(InstanceIds=[id])
    for data in ec2['Reservations']:
        for _ in data['Instances']:
            data = _['Tags']
            output_dict = [x for x in _['Tags'] if x['Key']
                           == 'Name' or x['Key'] == 'name']
            return output_dict[0]['Value']


def instanceSessionDataInformations():
    data = ssm.describe_instance_information()
    return data['InstanceInformationList']

def printInstanceSessionDataInformations():
    data = instanceSessionDataInformations()
    if data != []:
        for instance in data:
            print(findEc2InstanceName(instance['InstanceId']), instance['PlatformName'], instance['PlatformVersion'])
    else:
        print("There is no instance associated with ssm manager.")


printInstanceSessionDataInformations()
```

**_execution_**

```bash
python3 instance-information-use-ssm.py
```

_output_

**_senario 1_**

![image](https://user-images.githubusercontent.com/57703276/178131431-3526cead-3184-42dc-bee4-cf53c24b6271.png)

**_senario 4_**

![image](https://user-images.githubusercontent.com/57703276/179044458-c102aea5-6368-45ce-9b83-d800399cc24e.png)

_note_

It requires a session manager; without it, we cannot obtain OS information.


#####  https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html
