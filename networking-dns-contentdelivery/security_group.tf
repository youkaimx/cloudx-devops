resource "aws_security_group" "webserver" {
  name = "webserver-sg"
  description = "security group for webservers"
  vpc_id = aws_vpc.vpc-lab.id
}

data "http" "myip" {
  url = "http://ifconfig.me"
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  cidr_blocks = [ "${chomp(data.http.myip.body)}/32" ]
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.webserver.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  cidr_blocks       = [ "${chomp(data.http.myip.body)}/32" ]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.webserver.id
}