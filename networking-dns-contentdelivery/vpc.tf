resource "aws_vpc" "vpc-lab" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name             = "vpc-lab"
  }
}

data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id = aws_vpc.vpc-lab.id
  cidr_block = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.this.names[0]
  tags = {
    "Name" = "public subnet A"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id = aws_vpc.vpc-lab.id
  cidr_block = "10.0.20.0/24"
  availability_zone = data.aws_availability_zones.this.names[1]
  tags = {
    "Name" = "public subnet C"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.vpc-lab.id

}

resource "aws_route_table_association" "route_table_subnet_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "route_table_subnet_c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.this.id
}