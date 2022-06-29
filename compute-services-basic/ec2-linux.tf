resource "aws_instance" "web_server_imd" {
  ami = "ami-02d1e544b84bf7502"
  instance_type = "t3a.micro"
  key_name = aws_key_pair.key-pair.key_name
  security_groups = [ aws_security_group.ssh-in.name ]
  user_data = filebase64("user_data.sh")
    
  tags = {
    "Name" = "Web Server for IMD"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "http" "myip" {
  url = "http://ifconfig.me"
}

resource "aws_security_group" "ssh-in" {
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