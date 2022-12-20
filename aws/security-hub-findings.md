security-hub-findings.md

```py
import csv
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
_execution id_

```bash
sudo apt install awscli
sudo apt install python3-pip
pip3 install csv boto3
#export credentials
python3 filename.py
```
