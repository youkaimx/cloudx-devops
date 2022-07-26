#Add private subnets for DB
#
#
#



# Database subnets(private):
# name=private_db_a, cidr=10.10.20.0/24, az=a
resource "aws_subnet" "private_db_a" {
  vpc_id = aws_vpc.cloudx.id
  cidr_block = "10.10.20.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "private_db_a"
  }
}
# Database subnets(private):
# name=private_db_, cidr=10.10.21.0/24, az=a
resource "aws_subnet" "private_db_b" {
  vpc_id = aws_vpc.cloudx.id
  cidr_block = "10.10.21.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "private_db_b"
  }
}

# Database subnet (private):
#name=private_db_c, cidr=10.10.22.0/24, az=c
resource "aws_subnet" "private_db_c" {
  vpc_id = aws_vpc.cloudx.id
  cidr_block = "10.10.22.0/24"
  availability_zone = "us-east-2c"
  tags = {
    Name = "private_db_c"
  }
}

#Routing table and attach it with the Private subnets (name=private_rt)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.cloudx.id

  tags = {
    Name = "private_rt"
  }
}
resource "aws_route_table_association" "private_rt_private_subnet_a" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_db_a.id
}

resource "aws_route_table_association" "private_rt_private_subnet_b" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_db_b.id
}

resource "aws_route_table_association" "private_rt_private_subnet_c" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_db_c.id
}


# Subnet_group:
# name=ghost, subnet_ids={private_db_a,private_db_b,private_db_c}, description='ghost database subnet group'
resource "aws_db_subnet_group" "ghost" {
  name        = "ghost"
  description = "ghost database subnet group"
  subnet_ids = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_b.id,
    aws_subnet.private_db_c.id
  ]
}



