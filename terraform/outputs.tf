output "ec2_public_ip" { value = aws_eip.ip.public_ip }
output "ssh_example" { value = "ssh ubuntu@${aws_eip.ip.public_ip}" }