# Create custom ssh key-pair to access your ec2 instances:
# (refer to this document)
# Uppload it to AWS with name=ghost-ec2-pool


resource "aws_key_pair" "ghost_ec2_pool" {
  public_key = file("~/.ssh/id_rsa.pub")
  key_name = "ghost-ec2-pool"
}