resource "aws_security_group" "Web_SG" {
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

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    # security_groups = [ aws_security_group.App_SG.id ]
    cidr_blocks = [var.Internet]
  }

  tags = {Name = "Web_SG"}
}

# APP Tier Security Group

resource "aws_security_group" "App_SG" {
  
  vpc_id = var.vpc_id
  description = "Allow Traffic from Web Tier Security Group"

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [ aws_security_group.Web_SG.id ]
  }

  tags = {
    Name = "APP_SG"
  }
}