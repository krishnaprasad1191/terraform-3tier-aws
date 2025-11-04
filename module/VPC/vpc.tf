#Virtual Network
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = { Name = "${var.Vpc_Name}_VPC" }
}

# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "${var.Vpc_Name}_IGW"}
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

# Route_Tables

resource "aws_route_table" "Pub_RT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block=var.Internet
    gateway_id= aws_internet_gateway.igw.id
  }
  tags = { Name= "${var.Vpc_Name}_Pub_RT"}
}

resource "aws_route_table_association" "RT_Pubsub_assoc" {

  for_each = aws_subnet.Public_Subnets  #taking public subnets
  route_table_id = aws_route_table.Pub_RT.id
  subnet_id = each.value.id
}