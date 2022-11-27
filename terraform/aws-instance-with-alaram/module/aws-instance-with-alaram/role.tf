resource "aws_iam_role" "er" {
  count = var.creationOfIamInstanceProfile == false ? 0 : 1
  name  = "${var.roleName}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  count      = var.creationOfIamInstanceProfile == false ? 0 : length(var.awsManagedRoles)
  role       = aws_iam_role.er[0].name
  policy_arn = "arn:aws:iam::aws:policy/${var.awsManagedRoles[count.index]}"
}

resource "aws_iam_instance_profile" "aiip" {
  count = var.creationOfIamInstanceProfile == false ? 0 : 1
  name  = "${var.roleName}-ec2-role-profile"
  role  = aws_iam_role.er[0].name
}

