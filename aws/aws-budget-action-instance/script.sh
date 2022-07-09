#!/bin/bash

sleep 10

# CommandLine => Reference

instanceIds=$(aws ec2 describe-instances --filters "Name=tag:$7,Values=$8"  --query "Reservations[*].Instances[*].[InstanceId]" --region=$4 --output text | paste -s -d, -)

# export instanceIds=$(aws ec2 describe-instances --filters "Name=tag:$7,Values=$8"  --query "Reservations[*].Instances[*].[InstanceId]" --region=$4 --output text | paste -s -d, -)


# CommandLine => Reference
aws budgets create-budget-action --account-id $1 --budget-name $2 --notification-type ACTUAL --action-type RUN_SSM_DOCUMENTS --action-threshold ActionThresholdValue=90,ActionThresholdType=PERCENTAGE --definition "SsmActionDefinition={ActionSubType=$3,Region=$4,InstanceIds=[$instanceIds]}" --execution-role-arn $5 --approval-model AUTOMATIC --subscribers SubscriptionType=EMAIL,Address=$6

# Arguments => Reference
# $1 = ${aws_budgets_budget.ec2.account_id}
# $2 = ${aws_budgets_budget.ec2.name}
# $3 = ${var.ActionSubType}
# $4 = ${var.region}
# $5 = ${aws_iam_role.test_role.arn}
# $6 = ${var.group_email_address}
# $7 = ${var.tagName}
# $8 = ${var.tagValue}
