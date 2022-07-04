data "aws_vpc" "vpc" {
  default = true
}

resource "aws_key_pair" "key" {
   key_name = "default"
   public_key = file("~/.ssh/id_rsa.pub")
 }