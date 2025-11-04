resource "aws_security_group" "Web_sg" {
  vpc_id = aws_vpc.main.id
  
}