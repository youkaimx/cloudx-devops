
#name=mysql, description="defines access to ghost db":
#
#ingress rule_1: port=3306, source_security_group={ec2_pool}, protocol=tcp

# From task 4: Update DB, EFS security groups:
# name=mysql
# add ingress rule: port=3306, source_security_group={fargate_pool}, protocol=tcp
resource "aws_security_group" "mysql" {
  name              = "mysql"
  description       = "defines acess to ghost db"
  vpc_id = aws_vpc.cloudx.id
  ingress {    
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [ 
      aws_security_group.ec2_pool.id,
      aws_security_group.fargate_pool.id
      ]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [ "0.0.0.0/0" ]
  }
}