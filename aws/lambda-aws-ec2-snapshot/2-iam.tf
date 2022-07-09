resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.lambdaname}-iam-rule"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy" "policy" {
  name        = "${var.lambdaname}-iamrole-policy"
  path        = "/"
  description = "${var.lambdaname} iamrole policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:DescribeInsta*",
        "ec2:DescribeVolume*",
        "ec2:CreateTag*",
        "ec2:DescribeTag*",
        "ec2:DescribeSnapshot*",
        "ec2:DeleteSnapsho*",
        "ec2:CreateSnapsho*",
        "cloudwatch:*",
        "events:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy.arn
}