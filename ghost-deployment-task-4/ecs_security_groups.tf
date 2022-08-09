# Add security groups for ECS Fargate
# Add the following security group:
# name=fargate_pool, description="Allows access for Fargate instances":
# ingress rule_1: port=2049, source_security_group={efs}, protocol=tcp
# ingress rule_2: port=2368, source_security_group={alb}, protocol=tcp
# egress rule_1: allows any destination

resource "aws_security_group" "fargate_pool" {
  name              = "fargate_pool"
  description       = "Allows access for Fargate instances"
  vpc_id            = aws_vpc.cloudx.id
}

# Resource: aws_security_group_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
resource "aws_security_group_rule" "fargate_pool_ingress_rule_efs" {
  security_group_id        = aws_security_group.fargate_pool.id
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.efs.id
}

resource "aws_security_group_rule" "fargate_pool_ingress_rule_2" {
  security_group_id        = aws_security_group.fargate_pool.id
  type                     = "ingress"
  from_port                = 2368
  to_port                  = 2368
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
}


# The security group attached to the VPC endpoint must allow incoming connections on 
# port 443 from the private subnet of the VPC.
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html
resource "aws_security_group_rule" "fargate_pool_ingress_https" {
  security_group_id        = aws_security_group.fargate_pool.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks = [aws_vpc.cloudx.cidr_block]
}


resource "aws_security_group_rule" "fargate_pool_egress_rule" {
  security_group_id        = aws_security_group.fargate_pool.id
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  cidr_blocks              = [ "0.0.0.0/0" ]
}