#Virtual Network
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = { Name = "${var.Vpc_Name}_VPC" }
}

resource "aws_subnet" "Public_Subnets" {
  for_each = var.Public_Subnets

  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true
  tags = { Name = "${var.Vpc_Name}_${each.key}" }
}

resource "aws_subnet" "Private_Subnets" {
  for_each = var.Private_Subnets

  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = { Name = "${var.Vpc_Name}_${each.key}" }
}

# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "${var.Vpc_Name}_IGW"}
}

# NAT Gateway

resource "aws_eip" "NAT_eip" {
  domain = "vpc"
  tags = {Name = "${var.Vpc_Name}_EIP"}
}

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.NAT_eip.id
  subnet_id = values(aws_subnet.Public_Subnets)[0].id

  tags = { Name= "${var.Vpc_Name}_Nat_GW" }
  depends_on = [ aws_internet_gateway.igw ]
}
