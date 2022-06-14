resource "aws_instance" "instance" {
   instance_type = "t3a.micro"
   vpc_security_group_ids = [ aws_security_group.webserver.id ]
   subnet_id = aws_subnet.public_subnet_a.id
   ami = data.aws_ami.amazon_linux.id
   key_name = "personal-key"
   tags = {
    Name = "instance"
   }
}

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

resource "aws_key_pair" "personal-key" {
  key_name   = "personal-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name = "flow_logs"
}

data "aws_iam_policy_document" "vpc-flow-logs-assume-role" {
  statement {
    effect = "Allow"
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = [ "vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "vpc-flow-logs-publish-logs" {
  statement {
    effect = "Allow"
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
    ]
    resources = [ "*" ]
  }
}

resource "aws_iam_policy" "vpc-flow-logs-publisher-policy" {
  name = "vpc-flow-logs-publisher-policy"
  policy = data.aws_iam_policy_document.vpc-flow-logs-publish-logs.json
}

resource "aws_iam_role" "vpc-flow-logs-publisher-role" {
  name = "cloudx-vpc-flow-logs-publisher-role"
  assume_role_policy = data.aws_iam_policy_document.vpc-flow-logs-assume-role.json
}



resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.vpc-flow-logs-publisher-role.name
  policy_arn = aws_iam_policy.vpc-flow-logs-publisher-policy.arn
}

resource "aws_flow_log" "vpc-lab-flow-log" {
  iam_role_arn = aws_iam_role.vpc-flow-logs-publisher-role.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  traffic_type = "ALL"
  max_aggregation_interval = 60
  vpc_id = aws_vpc.vpc-lab.id
  tags = {
    Name = "VPC-Lab-Flow-Log"
  }
}