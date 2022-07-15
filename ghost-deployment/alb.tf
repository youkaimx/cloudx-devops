# Create Application Load Balancer with 1 target group:
#target group 1: name=ghost-ec2,port=2368,protocol="HTTP"
#reate ALB listener: port=80,protocol="HTTP", avalability zone=a,b,c
#Edit ALB listener rule: action type = "forward",target_group_1_weight=100

resource "aws_lb" "ghost_alb" {
   name               = "ghost-alb"
   internal           = false
   load_balancer_type = "application"
   security_groups    = [ aws_security_group.alb.id ]
   subnets            = [ aws_subnet.public_a.id, 
                          aws_subnet.public_b.id,
                          aws_subnet.public_c.id ]
 }

 resource "aws_lb_listener" "ghost_alb_listener_http" {
   load_balancer_arn   = aws_lb.ghost_alb.arn
   port                = "80"
   protocol            = "HTTP"
   default_action {
      type             = "forward"
      forward {
        target_group {
          arn = aws_lb_target_group.ghost_ec2.arn
          weight = 100
        }
      }
   }
 }

 resource "aws_lb_target_group" "ghost_ec2" {
  
   name               = "ghost-ec2"
   target_type        = "instance"
   protocol           = "HTTP"
   port               = 2368
   vpc_id             = aws_vpc.cloudx.id
   #health_check {
   #  path = "/ping"
   #}
 }