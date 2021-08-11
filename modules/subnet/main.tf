resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.environment_name}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.environment_name}-inernet-gateway"
  }
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = var.vpc_default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.environment_name}-main-r-table"
  }
}

resource "aws_route_table_association" "myapp-rt-association" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_default_route_table.main-rtb.id
}