data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_vpc" "vpc_simple" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = false
  enable_dns_support   = false
  tags                 = {}
}

resource "aws_subnet" "subnet_public" {
  availability_zone       = "us-west-2a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags                    = {}
  vpc_id                  = aws_vpc.vpc_simple.id
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  availability_zone      = "us-west-2a"
  instance_type          = "t3.micro"
  key_name               = ""
  subnet_id              = aws_subnet.subnet_public.id
  tags                   = {}
  vpc_security_group_ids = [aws_security_group.sg_web.id]
}

resource "aws_security_group" "sg_web" {
  description = "Managed by TerraFlow"
  name        = "sg_web"
  tags        = {}
  vpc_id      = aws_vpc.vpc_simple.id
}