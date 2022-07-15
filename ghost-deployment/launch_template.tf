# 
# In this task you have to author launch tempalate to run Ghost application with 
# UserData script on instance start up. Use Amazon Linux 2 as the base image.
# Start up script should do the following:
# Install pre-requirements
# Install, configure and run Ghost application
# Сreate Launch Template:

# name=ghost, instance_type=t2.micro, security_group={ec2_pool}, key_name={ghost-ec2-pool}, userdata={your_startup_script}

# To check script you can run single EC2 instance using Launch Template. Don't forget to remove it after testing.
# Hint: you can use cloud-init log to examine userData scipt output(/var/log/cloud-init-output.log)

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

resource "aws_launch_template" "ghost_launch_template" {
  depends_on = [
    aws_iam_instance_profile.ec2_instance_profile
  ]
  name                   = "ghost_launch_template"
#  image_id               = data.aws_ami.amazon_linux.id
  image_id               = "ami-02d1e544b84bf7502"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ghost_ec2_pool.key_name
  user_data              = filebase64("user_data.sh")
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [ aws_security_group.ec2_pool.id  ]
  }
  iam_instance_profile {
    name                 = aws_iam_instance_profile.ec2_instance_profile.name
  }
}

