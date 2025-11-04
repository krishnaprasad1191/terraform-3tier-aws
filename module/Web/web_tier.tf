resource "aws_security_group" "Web_sg" {
  vpc_id = var.vpc_id
  description = "Allow traffic 22 and 80 from anywhere"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.Internet]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.Internet]
  }

  ingress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.Internet]
  }

  tags = {Name = "Web_SG"}
}

