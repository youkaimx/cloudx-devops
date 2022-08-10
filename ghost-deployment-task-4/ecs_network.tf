# Add private subnets for ECS Fargate
# 3 x ECS subnets(private):
# name=private_a, cidr=10.10.10.0/24, az=a
# name=private_b, cidr=10.10.11.0/24, az=b
# name=private_c, cidr=10.10.12.0/24, az=c
# Attach ECS private subnets to private route table  (name=private_rt, check External DataBase)


# Database subnets(private):
# name=private_db_a, cidr=10.10.20.0/24, az=a
resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.cloudx.id
  cidr_block = "10.10.10.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "private_a"
  }
}
# Database subnets(private):
# name=private_db_, cidr=10.10.21.0/24, az=a
resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.cloudx.id
  cidr_block = "10.10.11.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "private_b"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id = aws_vpc.cloudx.id
  cidr_block = "10.10.12.0/24"
  availability_zone = "us-east-2c"
  tags = {
    Name = "private_c"
  }
}

resource "aws_route_table_association" "private_rt_private_a" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_a.id
}

resource "aws_route_table_association" "private_rt_private_b" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_b.id
}

resource "aws_route_table_association" "private_rt_private_c" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_c.id
}


### Endpoint test
resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
  vpc_id       = aws_vpc.cloudx.id
  private_dns_enabled = true
  service_name = "com.amazonaws.us-east-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.fargate_pool.id]
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id
 ]
}

resource "aws_vpc_endpoint" "ecr-api-endpoint" {
  vpc_id       = aws_vpc.cloudx.id
  private_dns_enabled = true
  service_name = "com.amazonaws.us-east-2.ecr.api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.fargate_pool.id]
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id
 ]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.cloudx.id
  service_name = "com.amazonaws.us-east-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.private_rt.id]
  policy = jsonencode({
   "Statement": [
     {
       "Sid": "Access-to-specific-bucket-only",
       "Principal": "*",
       "Action": [
         "s3:GetObject"
       ],
       "Effect": "Allow",
       "Resource": ["arn:aws:s3:::prod-us-east-2-starport-layer-bucket/*"]
     }
   ]
 })
}

resource "aws_vpc_endpoint" "efs-endpoint" {
  vpc_id       = aws_vpc.cloudx.id
  private_dns_enabled = true
  service_name = "com.amazonaws.us-east-2.elasticfilesystem"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.fargate_pool.id]
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id
 ]
}

# From https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html
# Create the CloudWatch Logs endpoint
# Amazon ECS tasks using the Fargate launch type that use a VPC without an internet gateway 
# that also use the awslogs log driver to send log information to CloudWatch Logs require that you
# create the com.amazonaws.region.logs interface VPC endpoint for CloudWatch Logs.
# For more information, see Using CloudWatch Logs with interface VPC endpoints in the Amazon 
# CloudWatch Logs User Guide.
resource "aws_vpc_endpoint" "logs-endpoint" {
  vpc_id       = aws_vpc.cloudx.id
  private_dns_enabled = true
  service_name = "com.amazonaws.us-east-2.logs"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.fargate_pool.id]
  subnet_ids = [ # Not sure if these are the correct subnets, as the db is not here
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id
 ]
}

# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/vpc-interface-endpoints.html
# You can create a VPC endpoint for the Amazon RDS API using either the Amazon VPC
# console or the AWS Command Line Interface (AWS CLI). For more information, see 
# Creating an interface endpoint in the Amazon VPC User Guide.
# Create a VPC endpoint for Amazon RDS API using the service name com.amazonaws.region.rds.
resource "aws_vpc_endpoint" "rds-endpoint" {
  vpc_id       = aws_vpc.cloudx.id
  private_dns_enabled = true
  service_name = "com.amazonaws.us-east-2.rds"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.mysql.id]
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id
 ]
}