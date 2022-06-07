data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "amzn2-ami-*" ]
  } 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

 
variable "environments" {
  default = {
  development  = "dev"
  production   = "prod"
  }
}

resource "aws_instance" "ec2_instances" {
  for_each      = var.environments
     
  ami           = data.aws_ami.amazon_linux.image_id
  instance_type = "t3a.micro"
  tags = {
    "Name" = "${each.value}-instance"
    "Env"  = each.value
  }

}