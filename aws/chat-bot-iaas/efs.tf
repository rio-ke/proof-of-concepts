resource "aws_efs_file_system" "efs" {
  creation_token = "my-product"
  tags           = merge(map("Name", "${var.project}-efs"), var.additional_tags)

}

resource "aws_efs_mount_target" "private-subnet-1-efs" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.private-subnet-1.id
  depends_on     = [aws_efs_file_system.efs]

}
resource "aws_efs_mount_target" "private-subnet-2-efs" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.private-subnet-2.id
  depends_on     = [aws_efs_file_system.efs]
}

resource "aws_default_security_group" "nfs-security-group" {

  ingress {
    cidr_blocks = [var.vpc_cidr]
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    description = "nfs-security-group"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id
  tags   = merge(map("Name", "${var.project}-nfs-security-group"), var.additional_tags)

}
