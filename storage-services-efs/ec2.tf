resource "aws_instance" "ec2" {     
  ami           = "ami-07251f912d2a831a3"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.EC2-sg.id ]
  key_name = aws_key_pair.key.key_name
}
#
output "EC2PublicIP" {
  value = aws_instance.ec2.public_ip
  description = "Newly created instance Public IP"
}
