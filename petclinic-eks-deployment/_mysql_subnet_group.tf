resource "aws_db_subnet_group" "rds" {
  name       = "petclinic"
  subnet_ids = flatten([aws_subnet.private_subnet.*.id])
  tags       = merge({ Name = "${var.eks_cluster_name}-${var.environment}-petclinic" }, tomap(var.additional_tags))
}

resource "aws_db_parameter_group" "rds" {
  name   = "${var.eks_cluster_name}-${var.environment}-petclinic"
  family = "mysql5.7"
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.eks_cluster_name}-${var.environment}-rds-security-group"
  description = "${var.eks_cluster_name}-${var.environment}-rds-security-group"
  vpc_id      = aws_vpc.custom_vpc.id
  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge({ Name = "${var.eks_cluster_name}-${var.environment}-rds-security-group" }, tomap(var.additional_tags))
}

resource "aws_db_instance" "mysql" {
  allocated_storage                     = 100
  auto_minor_version_upgrade            = true
  availability_zone                     = "us-east-1b"
  backup_retention_period               = 0
  delete_automated_backups              = true
  deletion_protection                   = false
  enabled_cloudwatch_logs_exports       = []
  engine                                = "mysql"
  engine_version                        = "5.7.38"
  iam_database_authentication_enabled   = false
  identifier                            = "petclinics"
  instance_class                        = "db.t3.medium"
  iops                                  = 3000
  max_allocated_storage                 = 200
  monitoring_interval                   = 0
  multi_az                              = false
  performance_insights_enabled          = false
  performance_insights_retention_period = 0
  port                                  = 3306
  publicly_accessible                   = false
  skip_final_snapshot                   = true
  storage_encrypted                     = false
  storage_type                          = "io1"
  tags                                  = merge({ Name = "${var.eks_cluster_name}-${var.environment}-rds" }, tomap(var.additional_tags))
  username                              = "petclinic"
  password                              = "petclinic"
  db_name                               = "petclinic"
  vpc_security_group_ids                = [ "${aws_security_group.rds.id}" ]
  db_subnet_group_name                  = aws_db_subnet_group.rds.name
  parameter_group_name                  = aws_db_parameter_group.rds.name
}
