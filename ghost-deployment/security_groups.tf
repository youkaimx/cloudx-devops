# Create security groups
# Create the following security groups:
# name=bastion, description="allows access to bastion":
# ingress rule_1: port=22, source={your_ip}, protocol=tcp
# egress rule_1: allows any destination

resource "aws_security_group" "bastion" {
  name          = "bastion"
  description   = "allows access to bastion"
  vpc_id        = aws_vpc.cloudx.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "${chomp(data.http.myip.body)}/32" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

data "http" "myip" {
  url           = "http://ifconfig.me"
}
 

# name=ec2_pool, description="allows access to ec2 instances":
# ingress rule_1: port=22, source_security_group={bastion}, protocol=tcp
# ingress rule_2: port=2049, source={vpc_cidr}, protocol=tcp
# ingress rule_3: port=2368, source_security_group={alb}, protocol=tcp
# egress rule_1: allows any destination
resource "aws_security_group" "ec2_pool" {
  name              = "ec2_pool"
  description       = "allows access to ec2 instances"
  vpc_id = aws_vpc.cloudx.id
  ingress {    
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [ aws_security_group.bastion.id ]
  }
  ingress {    
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    cidr_blocks = [ aws_vpc.cloudx.cidr_block ]
  }
  ingress {    
    from_port       = 2368
    to_port         = 2368
    protocol        = "tcp"
    security_groups = [ aws_security_group.alb.id ]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [ "0.0.0.0/0" ]
  }
}

# name=alb, description="allows access to alb":
# ingress rule_1: port=80, source={your_ip}, protocol=tcp
# egress rule_1: port=any, source_security_group={ec2_pool}, protocol=any
resource "aws_security_group" "alb" {
  name              = "alb"
  description       = "allows access to alb"
  vpc_id = aws_vpc.cloudx.id
  ingress {    
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = [ "${chomp(data.http.myip.body)}/32" ]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [ aws_vpc.cloudx.cidr_block ]
  }
}