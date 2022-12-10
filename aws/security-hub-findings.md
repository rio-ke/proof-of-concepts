security-hub-findings.md


```py
import boto3
import json
client = boto3.client('securityhub')


filter = Filters = {
    'AwsAccountId': [
        {
            'Value': '412725174439',
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
