data "aws_vpc" "default" {
  default = true
}

data "http" "myip" {
  url = "http://ifconfig.me"
}