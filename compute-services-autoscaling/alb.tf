# Tries to satisfy 
# https://aws.amazon.com/ru/getting-started/hands-on/ec2-auto-scaling-spot-instances/?trk=gs_card

data "aws_vpc" "default_vpc" {
  default = true
}
  
data "aws_subnets" "subnets" {
  filter {
    name = "vpc-id"
    values = [  data.aws_vpc.default_vpc.id ]
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_lb" "load_balancer" {
  name = "cloudx-devops-lb"
  internal = false
  load_balancer_type = "application"
  subnets =  "${data.aws_subnets.subnets.ids[*]}" 
  security_groups = [ aws_security_group.load_balancer_sg.id ]
}

resource "aws_security_group" "load_balancer_sg" {
  name = "cloudx-devops-lb-sg"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTP"
    from_port = 80
    protocol = "tcp"
    to_port = 80
  }
  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}

resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

resource "aws_key_pair" "key_pair" {
  key_name = "lab_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_launch_template" "launch_template" {
  name                   = "cloudx-devops-launch-template"
  image_id               = "ami-02d1e544b84bf7502"
  instance_type          = "t3a.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [ "${aws_security_group.load_balancer_sg.id}" ]
  user_data              = filebase64("user_data.sh")
  
  
}

resource "aws_autoscaling_group" "lab_asg" {
  name                   = "cloudx-devops-asg"
  availability_zones     =  data.aws_availability_zones.azs.names 
  target_group_arns = [ aws_lb_target_group.lb_target_group.arn ]
  min_size               = 3
  max_size               = 6
  desired_capacity       = 6
  health_check_type      = "EC2"
  
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity = 0
      on_demand_percentage_above_base_capacity = 10
      spot_allocation_strategy = "capacity-optimized"
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.launch_template.id
      }
    }
  }
}

resource "aws_autoscaling_policy" "cpu_target_tracking_policy" {
  name = "cpu_target_tracking_policy"
  policy_type = "SimpleScaling"
  adjustment_type = "ChangeInCapacity" 
  cooldown = 300
  scaling_adjustment = 1
  autoscaling_group_name = aws_autoscaling_group.lab_asg.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_up_alarm" {
  alarm_name = "cpu_up_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  threshold = 50
  period = 120
  statistic = "Average"
  namespace = "AWS/EC2"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.lab_asg.name
  }
  alarm_actions = [ aws_autoscaling_policy.cpu_target_tracking_policy.arn ]
}

resource "aws_lb_target_group" "lb_target_group" {
   name               = "lb-target-group"
   target_type        = "instance"
   port               = 80
   protocol           = "HTTP"
   vpc_id             = "${data.aws_vpc.default_vpc.id}"

   health_check {
     path = "/"
   }
 }


