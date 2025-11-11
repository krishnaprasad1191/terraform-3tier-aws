resource "aws_security_group" "DB_SG" {
  vpc_id = var.vpc_id
  description = "Allow traffic to MySQL only from App SG"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [var.app_sg_id]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "DB_Secgrp" }
}

output "DB_SG_ID" {
  value = aws_security_group.DB_SG.id
}

resource "aws_db_subnet_group" "db_subnet_grp" {
    name = "db_subnet_group"
    subnet_ids = [ var.Pvtsubnet3_id, var.Pvtsubnet4_id ]
}

resource "aws_db_instance" "MySQL-DB" {

    identifier = var.identifier
    engine = var.engine_type
    engine_version = var.engine_version
    allocated_storage = var.storage
    username = var.db_username
    password = var.db_password
    instance_class = var.instance_class
    skip_final_snapshot = true
    publicly_accessible = false
    db_subnet_group_name = aws_db_subnet_group.db_subnet_grp.name
    vpc_security_group_ids = [aws_security_group.DB_SG.id]

    depends_on = [ aws_db_subnet_group.db_subnet_grp ]
}

