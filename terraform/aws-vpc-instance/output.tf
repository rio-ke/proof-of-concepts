output "instance_public_ip" {
    value = aws_instance.ai.public_ip
}

output "instance_private_ip" {
    value = aws_instance.ai.private_ip
}