data "template_file" "tf" {
  template = file("script/main.sh")
}


resource "aws_instance" "ai" {
  ami                    = var.AMI
  instance_type          = local.INSTANCE_TYPE
  key_name               = aws_key_pair.akp.key_name
  vpc_security_group_ids = [aws_security_group.asg.id]
  subnet_id              = aws_subnet.as.id
  user_data              = data.template_file.tf.rendered
  tags = {
    Name = "${var.PROJECT}-${local.SELECT_NUMBER}-instance"
  }
  depends_on = [
    aws_key_pair.akp,
    aws_security_group.asg
  ]
}
