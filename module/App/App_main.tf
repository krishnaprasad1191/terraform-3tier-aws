resource "aws_security_group" "APP_Tier_SG" {
  vpc_id = var.vpc_id
  description = "Allow SSH from Web Servers"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [var.Web_Secgrp_id]
  }

  ingress {
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  security_groups = [var.Web_Secgrp_id]
  description     = "Allow HTTP from Web Tier"
}

ingress {
  from_port = -1
  to_port = -1
  protocol = "icmp"
  security_groups = [ var.Web_Secgrp_id ]
}

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

    tags = { Name = "APP_SG" }
}

resource "aws_lb_target_group" "Pvt_vm_TG" {
  vpc_id = var.vpc_id
  port = 80
  target_type = "instance"
  protocol = "HTTP"

  health_check {
    path = "/"
  }

  tags = {
    Name = "App-Tier-TG"
  }

}

resource "aws_lb" "APP_Tier_LB" {
  name = "APP-Tier-LB"
  load_balancer_type = "application"
  internal = true
  security_groups = [aws_security_group.APP_Tier_SG.id]
  subnets = [var.private_subnet1_id,var.private_subnet2_id]
}
#Adding Http listner and attaching TG
resource "aws_lb_listener" "APP_http_listner" {
  load_balancer_arn = aws_lb.APP_Tier_LB.arn
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.Pvt_vm_TG.arn
    type = "forward"
  }
}

resource "aws_launch_template" "App_Tier_LT" {
  name_prefix = var.LT_name
  instance_type = var.instance_type
  image_id = var.AMI
  key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.APP_Tier_SG.id ]

    tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Application_Instance"
    }
    }

  monitoring {
    enabled = true
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash
  sudo apt update && sudo apt install nginx -y
  sudo systemctl enable nginx
  sudo systemctl start nginx
  echo "Hello from Auto Scaling Group!" > /var/www/html/index.html
  EOF
  )
}
resource "aws_autoscaling_group" "App_Tier_ASG" {
  name = "App_ASG"
  desired_capacity = 1
  min_size = 1
  max_size = 2
  vpc_zone_identifier = [ var.private_subnet1_id, var.private_subnet2_id ]
  target_group_arns = [ aws_lb_target_group.Pvt_vm_TG.arn ]
  health_check_grace_period = 300
  health_check_type = "ELB"

  launch_template {
    id = aws_launch_template.App_Tier_LT.id
    version = "$Latest"
  }

    tag {
    key                 = "Name"
    value               = "App-ASG-Instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
  aws_lb.APP_Tier_LB,
  aws_lb_target_group.Pvt_vm_TG,
  aws_lb_listener.APP_http_listner
]
}