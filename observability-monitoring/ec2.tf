# https://catalog.workshops.aws/general-immersionday/en-US/basic-modules/40-monitoring/monitoring/2-monitoring
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "amzn2-*" ]
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

# resource "aws_key_pair" "name" {
#   key_name = "lab-key"
#   public_key = file("~/.ssh/id_rsa.pub")
# }

resource "aws_instance" "name" {
#  ami = "ami-02d1e544b84bf7502"
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t3a.micro"
#  key_name       = aws_key_pair.name.key_name
  user_data       = filebase64("user_data.sh")
  # To have detailed monitoring enabled https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#monitoring
  monitoring      = true

  tags = {
    "Name"        = "Lab Server"
  }
}

