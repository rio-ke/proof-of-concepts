import sys
from pip._internal import main

main(['install', '-I', '-q', 'boto3', '--target', '/tmp/', '--no-cache-dir', '--disable-pip-version-check'])
sys.path.insert(0,'/tmp/')

import boto3
import os
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


REGION = os.environ['region']
ROLE = os.environ['executionRole']
BUDGET_NAME = os.environ['budgetName']

tagname = "office-hours"
tagvalue = "ec-data-platform"

ec2 = boto3.client('ec2', region_name="eu-west-1")
response = ec2.describe_instances(
    Filters=[
        {
            'Name': 'tag:'+tagname,
            'Values': [tagvalue]
        }
    ]
)

instancelist = []
for reservation in (response["Reservations"]):
    for instance in reservation["Instances"]:
        instancelist.append(instance["InstanceId"])

ACCOUNT_ID = boto3.client('sts').get_caller_identity()['Account']

NOTIFICATION_LISTS = [{
    'NotificationType': "ACTUAL",
    'ComparisonOperator': "GREATER_THAN",
    'Threshold': 80,
    'NotificationState': 'ALARM'
},
    {
    'NotificationType': "ACTUAL",
    'ComparisonOperator': "GREATER_THAN",
    'Threshold': 90,
    'NotificationState': 'ALARM'
},
    {
    'NotificationType': "FORECASTED",
    'ComparisonOperator': "GREATER_THAN",
    'Threshold': 100,
    'NotificationState': 'ALARM'
},
    {
    'NotificationType': "ACTUAL",
    'ComparisonOperator': "EQUAL_TO",
    'Threshold': 100,
    'NotificationState': 'ALARM'
}]

emailaddress = [
    "jino@gmail.com",
    "jinoj@gmail.com",
    "jjino@gmail.com",
    "jjinojj@gmail.com"
]


def CreateNotification(AccountId, BudgetName, NotificationItem, Address):
    client = boto3.client('budgets')
    client.create_notification(
        AccountId=AccountId,
        BudgetName=BudgetName,
        Notification=NotificationItem,
        Subscribers=[
            {
                'SubscriptionType': 'EMAIL',
                'Address': Address
            }
        ]
    )
    print('Created')


def DeleteCreateNotification(AccountId, BudgetName):

    client = boto3.client('budgets')
    EXIST_NOTIFICATION = client.describe_notifications_for_budget(
        AccountId=ACCOUNT_ID, BudgetName=BUDGET_NAME)
    NOTIFICATIONS_AVAILABLE = (len(EXIST_NOTIFICATION['Notifications']))
    if "Notifications" in EXIST_NOTIFICATION:
        for i in range(NOTIFICATIONS_AVAILABLE):
            client.delete_notification(
                AccountId=AccountId,
                BudgetName=BudgetName,
                Notification=EXIST_NOTIFICATION['Notifications'][i],
            )
            print('deleted')

    TOTALALERTS = len(NOTIFICATION_LISTS)
    for i in range(TOTALALERTS):
        CreateNotification(AccountId=ACCOUNT_ID, BudgetName=BUDGET_NAME,
                           NotificationItem=NOTIFICATION_LISTS[i], Address=emailaddress[i])


def CreateBudgetAction(AccountId, BudgetName, ExecutionRoleArn, Region, Address):
    client = boto3.client('budgets')
    client.create_budget_action(
        AccountId=AccountId,
        BudgetName=BudgetName,
        NotificationType='ACTUAL',
        ActionType='RUN_SSM_DOCUMENTS',
        ActionThreshold={
            'ActionThresholdValue': 100,
            'ActionThresholdType': 'PERCENTAGE'
        },
        Definition={
            'SsmActionDefinition': {
                'ActionSubType': 'STOP_EC2_INSTANCES',
                'Region': REGION,
                'InstanceIds': instancelist
            }
        },
        ExecutionRoleArn=ROLE,
        ApprovalModel='AUTOMATIC',
        Subscribers=[
            {
                'SubscriptionType': 'EMAIL',
                'Address': Address
            },
        ]
    )


def lambda_handler(event, context):
    client = boto3.client('budgets')
    response = client.describe_budgets(AccountId=ACCOUNT_ID)
    if "Budgets" in response:
        TOTAL_BUDGETS = len(response['Budgets'])
        for i in range(TOTAL_BUDGETS):
            if (response['Budgets'][i]['BudgetName']) == BUDGET_NAME:
                DeleteCreateNotification(
                    AccountId=ACCOUNT_ID, BudgetName=BUDGET_NAME)
        if instancelist != '':
            CreateBudgetAction(AccountId=ACCOUNT_ID,BudgetName=BUDGET_NAME, ExecutionRoleArn=ROLE, Region=REGION, Address=emailaddress[0])

    else:
        response = client.create_budget(
            AccountId=ACCOUNT_ID,
            Budget={
                'BudgetName': BUDGET_NAME,
                'BudgetLimit': {
                    'Amount': '400',
                    'Unit': 'USD'
                },
                'CostFilters': {
                    "TagKeyValue": ["office-hours:Key$ec-data-platform"]
                },
                'CostTypes': {
                    'IncludeTax': False,
                    'IncludeSubscription': True,
                    'UseBlended': False,
                    'IncludeRefund': False,
                    'IncludeCredit': False,
                    'IncludeUpfront': False,
                    'IncludeRecurring': False,
                    'IncludeOtherSubscription': False,
                    'IncludeSupport': False,
                    'IncludeDiscount': False,
                    'UseAmortized': False
                },
                'TimeUnit': 'MONTHLY',
                'TimePeriod': {
                    'Start': "25/11/2020 00:00 UTC",
                    'End': "25/12/2020 00:00 UTC"
                },
                'BudgetType': 'COST'
            }
        )

        TOTALALERTS = len(NOTIFICATION_LISTS)
        for i in range(TOTALALERTS):
            CreateNotification(AccountId=ACCOUNT_ID, BudgetName=BUDGET_NAME,
                               NotificationItem=NOTIFICATION_LISTS[i], Address=emailaddress[i])
        if instancelist != '':
            CreateBudgetAction(AccountId=ACCOUNT_ID,BudgetName=BUDGET_NAME, ExecutionRoleArn=ROLE, Region=REGION, Address=emailaddress[0])
