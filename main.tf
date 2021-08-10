provider "aws" {
  region     = "eu-west-3"
}

variable "cidr_block" {
  description = "cidr block for vpc and subenets"
  type = list(object({
    cidr_block = string
    name       = string
  }))
}

variable "environment_name" {
  description = "environment name stage or prod"
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.cidr_block[0].cidr_block
  tags = {
    Name             = var.cidr_block[0].name
    environment_name = var.environment_name
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = var.cidr_block[1].cidr_block
  availability_zone = "eu-west-3a"
  tags = {
    Name             = var.cidr_block[1].name
    environment_name = var.environment_name
  }
}

output "aws-vpc-id" {
  value = aws_vpc.development-vpc.id
}

output "aws-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}