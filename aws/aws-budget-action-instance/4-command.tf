resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "bash script.sh ${aws_budgets_budget.ec2.account_id} ${aws_budgets_budget.ec2.name} ${var.ActionSubType} ${var.region} ${aws_iam_role.test_role.arn} ${var.group_email_address} ${var.tagName} ${var.tagValue}"
  }
  depends_on = [aws_iam_role_policy_attachment.test-attach, aws_budgets_budget.ec2]
}
