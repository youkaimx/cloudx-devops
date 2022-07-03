data "aws_ssm_parameter" "AmiID" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "StackName" {
  default = "S3-General-ID-Lab"
}

variable "InstanceType" {
  default = "t2.micro"
  description = "Web Host EC2 instance type"
}

data "http" "myip" {
    url = "http://ifconfig.me"
 }

 resource "aws_key_pair" "name" {
   key_name = "default"
   public_key = file("~/.ssh/id_rsa.pub")
 }
   

resource "aws_security_group" "WebhostSecurityGroup" {
  name = "${var.StackName} - Website Security Group"
  description = "Allow ACcess to the Webhost on Port 80"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  } 
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

resource "aws_instance" "ec2_instances" {     
  ami           = data.aws_ssm_parameter.AmiID.value
  instance_type = var.InstanceType 
  user_data = file("user_data.sh")
  iam_instance_profile = aws_iam_instance_profile.name.name
  security_groups = [ "${aws_security_group.WebhostSecurityGroup.name}" ]
  key_name = aws_key_pair.name.key_name
  tags = {
    "Name" = "${var.StackName}"
  }
}

output "PublicIP" {
  value = aws_instance.ec2_instances.public_ip
  description = "Newly created webhost Public IP"
}

output "PublicDNS" {
  value = aws_instance.ec2_instances.public_dns
  description = "Newly created webhost Public DNS URL"
}