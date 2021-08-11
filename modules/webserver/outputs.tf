output "aws_latest_amazon_linux_images" {
  value = data.aws_ami.latest_amazon_linux-img.id
}

output "instance_ip_address" {
    value = aws_instance.myapp-server.public_ip
}