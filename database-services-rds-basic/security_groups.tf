resource "aws_security_group" "db" {
  name          = "Immersion Day DB Tier"
  description   = "Immersion Day DB Tier"
  vpc_id        = data.aws_vpc.default.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [ aws_security_group.web_server.id ]
  }
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

resource "aws_security_group" "web_server" {
  vpc_id = data.aws_vpc.default.id
  name = "Immersion Day - Web Server"
  description = "Immersion Day - Web Server"
  ingress {
    cidr_blocks = [ "${chomp(data.http.myip.body)}/32" ]
    description = "SSH"
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  ingress {
    cidr_blocks = [ "${chomp(data.http.myip.body)}/32" ]
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