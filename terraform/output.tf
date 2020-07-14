output "instance_static_public_ip_addr" {
  value = aws_eip.instance_1_static_ip.public_ip
}
