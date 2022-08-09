# Create Auto-scaling group and assign it with Launch Template from step 5:
#  name=ghost_ec2_pool
# avalability zone=a,b,c
# Attach ASG with {ghost-ec2} target group

resource "aws_autoscaling_group" "ghost_ec2_pool" {
  name                   = "ghost_ec2_pool" 
  target_group_arns = [ aws_lb_target_group.ghost_ec2.arn ]
  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id
  ]
  min_size               = 1
  max_size               = 3
  desired_capacity       = 2
  health_check_type      = "EC2"
  
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity = 0
      on_demand_percentage_above_base_capacity = 10
      spot_allocation_strategy = "capacity-optimized"
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ghost_launch_template.id
      }
    }
  }
}