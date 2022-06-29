resource "aws_key_pair" "key-pair" {
  key_name = "AWS-ImmersionDay"
  public_key = file("~/.ssh/id_rsa.pub")
}