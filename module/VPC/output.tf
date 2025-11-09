output "vpc_id" { value = aws_vpc.main.id }
output "nat_gateway_id" {value = aws_nat_gateway.NAT.id}
output "aws_internet_gateway_id" {value = aws_internet_gateway.igw.id}

output "Pubsub01_id" {
  value = values(aws_subnet.Public_Subnets)[0].id
}

output "Pubsub02_id" {
  value = values(aws_subnet.Public_Subnets)[1].id
}

output "Pvtsub01_id" {
  value = values(aws_subnet.Private_Subnets)[0].id
}

output "Pvtsub02_id" {
  value = values(aws_subnet.Private_Subnets)[1].id
}