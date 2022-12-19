security-hub-findings.md


```py
import boto3
import json
client = boto3.client('securityhub')


filter = Filters = {
    'AwsAccountId': [
        {
            'Value': 'xxxx',
            'Comparison': 'EQUALS'
        },
    ],
    "SeverityLabel": [
        {
            "Value": "CRITICAL",
            "Comparison": "EQUALS"
        },
        {
            "Value": "HIGH",
            "Comparison": "EQUALS"
        }
    ],
    "RecordState": [
        {
            "Comparison": "EQUALS",
            "Value": "ACTIVE"
        }
    ],
    'ComplianceStatus': [
        {
            'Value': 'FAILED',
            'Comparison': 'EQUALS'
        }
    ]
}


# response = client.get_findings(Filters=filter, MaxResults=100)
# response = client.get_findings(MaxResults=100)
response = client.get_findings()


for versions in response['Findings']:
    version = json.loads(json.dumps(versions))
    print(version['ProductName'])
    print(version['Title'])
    # print(version['FirstObservedAt'])
    # print(version['LastObservedAt'])
    # print(version['CreatedAt'])
    # print(version['UpdatedAt'])
    print(version['Description'])
    print(version['AwsAccountId'])
    print(version['Severity']['Label'])
    print(version['RecordState'])
    print("")


print(len(response))

```


```py
import csv
import pandas as pd
import boto3
import json
client = boto3.client('securityhub')

filter = Filters = {
    'AwsAccountId': [
        {
            'Value': 'xxxx',
            'Comparison': 'EQUALS'
        },
    ],
    "SeverityLabel": [
        {
            "Value": "CRITICAL",
            "Comparison": "EQUALS"
        },
        {
            "Value": "HIGH",
            "Comparison": "EQUALS"
        }
    ],
    "RecordState": [
        {
            "Comparison": "EQUALS",
            "Value": "ACTIVE"
        }
    ],
    'ComplianceStatus': [
        {
            'Value': 'FAILED',
            'Comparison': 'EQUALS'
        }
    ]
}


response = client.get_findings(Filters=filter, MaxResults=100)
row_list = [('serial', 'AwsAccountId',
             'Severity', 'RecordState', 'ProductName', 'Title', 'Description', 'Remediation')]

index = 1
for versions in response['Findings']:
    version = json.loads(json.dumps(versions))
    _data = index, version['AwsAccountId'], version['Severity']['Label'], version[
        'RecordState'], version['ProductName'], version['Title'], version['Description'], version['Remediation']['Recommendation']['Url']
    row_list.append(_data)
    index += 1

with open('reports.csv', 'w', newline='') as file:
    writer = csv.writer(file, delimiter=';')
    writer.writerows(row_list)

```
