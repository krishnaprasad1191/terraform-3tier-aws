# Target group
resource "aws_lb_target_group" "Pubvm_TG" {
  vpc_id = var.vpc_id
  name = "Web-Tier-TG"
  port = 80
  target_type = "instance"
  protocol = "HTTP"

  health_check {
    path = "/"
  }

}

# resource "aws_lb_target_group_attachment" "pubvm1_attach_TG" {
#   target_group_arn = aws_lb_target_group.Pubvm_TG.arn
#   target_id = aws_instance.Public_instance_1.id
#   port = 80
# }

# resource "aws_lb_target_group_attachment" "pubvm2_attach_TG" {
#   target_group_arn = aws_lb_target_group.Pubvm_TG.arn
#   target_id = aws_instance.Public_instance_2.id
#   port = 80
# }

######################################################################################################
#Load Balancer
resource "aws_lb" "Web_Tier_LB" {
  name = "Web-LB"
  load_balancer_type = "application"
  security_groups = [aws_security_group.Web_SG.id]
  subnets = [var.public_subnet1_id,var.public_subnet2_id]

  
}
#Adding Http listner and attaching TG
resource "aws_lb_listener" "Web_http_listner" {
  load_balancer_arn = aws_lb.Web_Tier_LB.arn
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.Pubvm_TG.arn
    type = "forward"
  }
}
# Adding HTTPS listner and attaching TG
# resource "aws_lb_listener" "https_listner" {
#   load_balancer_arn = aws_lb.Web_LB.arn
#   protocol = "HTTPS"
#   port = 443
#   default_action {
#     target_group_arn = aws_lb_target_group.Pubvm_TG.arn
#     type = "forward"
#   }
# }

resource "aws_launch_template" "Web_LT" {
  name_prefix = var.LT_name
  instance_type = var.instance_type
  image_id = data.aws_ami.Ubuntu_AMI.id
  key_name = data.aws_key_pair.Keypair.key_name
  vpc_security_group_ids = [ aws_security_group.Web_SG.id ]

    tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Web_Tier_Instance"
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

resource "aws_autoscaling_group" "Web_ASG" {
  name = "Web_ASG"
  min_size = 1
  max_size = 3
  desired_capacity = 2
  vpc_zone_identifier = [var.public_subnet1_id,var.public_subnet2_id]
  target_group_arns = [aws_lb_target_group.Pubvm_TG.arn]
  health_check_type =  "ELB"
  health_check_grace_period = 300

  launch_template {
    id = aws_launch_template.Web_LT.id
    version = "$Latest"
  }
  
  tag {
    key                 = "Name"
    value               = "Web-ASG-Instance"
    propagate_at_launch = true
  }

  depends_on = [
  aws_lb.Web_Tier_LB,
  aws_lb_target_group.Pubvm_TG,
  aws_lb_listener.Web_http_listner
]

}