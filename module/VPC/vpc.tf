resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.Name
  }
}

resource "aws_subnet" "Pub_Subnet01" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.Pub_Subnet01_cidr
  map_public_ip_on_launch = true
  availability_zone = var.AZ1
}