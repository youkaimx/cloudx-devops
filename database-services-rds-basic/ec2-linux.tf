resource "aws_instance" "web_server_imd" {
  ami = "ami-02d1e544b84bf7502"
  instance_type = "t3a.micro"
  key_name = aws_key_pair.key-pair.key_name
  vpc_security_group_ids = [ aws_security_group.web_server.id ] 
  user_data = filebase64("user_data.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.id
  tags = {
    "Name" = "Web Server for IMD"
  }
}


