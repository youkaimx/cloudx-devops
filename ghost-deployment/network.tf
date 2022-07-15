# Create Network stack
# Create network stack for your infrastructure with the following resources:
# 
# VPC: name=cloudx, cidr=10.10.0.0/16, enable_dns_support=true, enable_dns_hostnames=true 

resource "aws_vpc" "cloudx" {
  cidr_block      = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name                 = "cloudx"
  }
}

# 3 x Public subnets:
# name=public_a, cidr=10.10.1.0/24, az=a
resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.cloudx.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "public_a"
  }
}
# name=public_b, cidr=10.10.2.0/24, az=b
resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.cloudx.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "public_b"
  }
}
# name=public_c, cidr=10.10.3.0/24, az=c
resource "aws_subnet" "public_c" {
  vpc_id = aws_vpc.cloudx.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "us-east-2c"
  tags = {
    Name = "public_c"
  }
}

# Internet gateway (name=cloudx-igw) and attach it to appropriate VPC
resource "aws_internet_gateway" "cloudx-igw" {
  vpc_id = aws_vpc.cloudx.id
  tags = {
    Name = "cloudx-igw"
  }
}
# Routing table to bind Internet gateway with the
# Public subnets (name=public_rt)

resource "aws_default_route_table" "public_rt" {
  default_route_table_id = aws_vpc.cloudx.default_route_table_id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudx-igw.id
  }
  tags = {
    Name = "public_rt"
  }
}

