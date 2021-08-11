provider "aws" {
  region = "eu-west-3"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.environment_name}-vpc"
  }
}

module "myapp_subnet" {
  source = "./modules/subnet"  
  vpc_id = "${aws_vpc.myapp-vpc.id}"
  avail_zone = var.avail_zone
  subnet_cidr_block = var.subnet_cidr_block
  environment_name = var.environment_name
  vpc_default_route_table_id = "${aws_vpc.myapp-vpc.default_route_table_id}"
}

module "app_server" {
  source = "./modules/webserver"
  vpc_id = "${aws_vpc.myapp-vpc.id}"
  environment_name = var.environment_name
  subnet_id = module.myapp_subnet.subnet.id
  ssh_public_key = "~/.ssh/id_rsa.pub"
}

output "myapp-vpc-id" {
  value = aws_vpc.myapp-vpc.id
}

output "myapp-subnet-id" {
  value = module.myapp_subnet.subnet.id
}

output "public_ip_address" {
  value = module.app_server.instance_ip_address
}