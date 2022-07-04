data "http" "myip" {
  url = "http://ifconfig.me"
}

resource "aws_security_group" "EC2-sg" {
  name = "EC2-sg"
  description = "Attached to the EC2 instance and it allows only SSH connection inbound to the EC2 instance and any outbound connectivity"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  } 
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "EFS-sg" {
  name = "EFS-sg"
  description = "Attached to the EFS file system and allows only TCP connection on port 2409 from the EC2 instance"
  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    security_groups = [ aws_security_group.EC2-sg.id ]
  } 
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}