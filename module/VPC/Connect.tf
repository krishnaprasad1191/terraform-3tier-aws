# Route_Tables

#Public RT
resource "aws_route_table" "Pub_RT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block=var.Internet
    gateway_id= aws_internet_gateway.igw.id
  }
  tags = { Name= "${var.Vpc_Name}_Pub_RT"}
}

#Public RT Assoc
resource "aws_route_table_association" "RT_Pubsub_assoc" {

  for_each = aws_subnet.Public_Subnets  #taking public subnets
  route_table_id = aws_route_table.Pub_RT.id
  subnet_id = each.value.id
}

#Private RT
resource "aws_route_table" "Pvt_RT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.Internet
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
  tags = { Name = "${var.Vpc_Name}_Pvt_RT" }
}

#Private RT Assc
resource "aws_route_table_association" "PvtRT_assoc" {
  for_each = aws_subnet.Private_Subnets
  route_table_id = aws_route_table.Pvt_RT.id
  subnet_id = each.value.id
}