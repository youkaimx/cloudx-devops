# Create EC2 instance:
# name: bastion # instance_type: t2.micro
# AMI: Amazon Linux 2 # associate_public_ip_address: true
# security_group: {bastion} # key_name: {ghost-ec2-pool}
# Try to connect to your ec2_pool instance by ssh

resource "aws_instance" "bastion" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_a.id
  vpc_security_group_ids = [ aws_security_group.bastion.id ]
  key_name = aws_key_pair.ghost_ec2_pool.key_name
  tags = {
    Name = "bastion"
  }
}