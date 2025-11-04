output "vpc_id" { value = aws_vpc.main.id }
output "nat_gateway_id" {value = aws_nat_gateway.NAT.id}
output "aws_internet_gateway_id" {value = aws_internet_gateway.igw.id}