
resource "aws_iam_role" "er" {
  name = "${var.roleName}-role"
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
  for_each   = toset(local.awsManagedRoles)
  role       = aws_iam_role.er.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}

resource "aws_iam_instance_profile" "aiip" {
  name = "${var.roleName}-ec2-role-profile"
  role = aws_iam_role.er.name
}

resource "aws_ssm_parameter" "parameter" {
  data_type = "text"
  name      = var.ssmParameterName
  tier      = "Standard"
  type      = "String"
  value     = file("${path.module}/config.json")
}

data "template_file" "windows-userdata" {
  template = <<EOF
        <powershell>
        $url = "https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/AmazonCloudWatchAgent.zip"
        $output = $env:TEMP + "\AmazonCloudWatchAgent.zip"
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($url, $output)
        Expand-Archive -path $output -destinationpath $env:TEMP
        cd $env:TEMP
        ./install.ps1
        Set-Location -Path 'C:\Program Files\Amazon\AmazonCloudWatchAgent'
        ./amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -c ssm:"${var.ssmParameterName}" -s
        </powershell>
    EOF
}


resource "aws_instance" "windows-server" {
  ami                         = "ami-0c95d38b24a19de18"
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-00235cf781f11cfce"
  vpc_security_group_ids      = ["sg-002fa6f2e165fc0eb"]
  key_name                    = "new"
  associate_public_ip_address = true
  # below two lines needs to be added
  iam_instance_profile        = aws_iam_instance_profile.aiip.name
  user_data                   = data.template_file.windows-userdata.rendered

}
