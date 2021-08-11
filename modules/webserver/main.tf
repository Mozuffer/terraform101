
resource "aws_default_security_group" "default-sg" {
  vpc_id = var.vpc_id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
  }
  egress {
    cidr_blocks     = ["0.0.0.0/0"]
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    prefix_list_ids = []
  }
  tags = {
    Name = "${var.environment_name}-default-sg"
  }
}

data "aws_ami" "latest_amazon_linux-img" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "server-key-pair" {
  key_name = "server-key-pair"
  public_key = file(var.ssh_public_key)
}

resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.latest_amazon_linux-img.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  security_groups             = [aws_default_security_group.default-sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.server-key-pair.key_name
  user_data = file("./userdata.sh")
  tags = {
    Name = "${var.environment_name}-myapp-server"
  }
}