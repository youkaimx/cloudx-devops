data "aws_iam_policy_document" "ghost_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ghost_role" {
  name               = "ghost_role"
  assume_role_policy = data.aws_iam_policy_document.ghost_assume_role_policy.json
}

# 
# Update IAM Role, add new permissions:
# "ssm:GetParameter*",
# "secretsmanager:GetSecretValue",
# "kms:Decrypt"

data "aws_iam_policy_document" "ghost_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "elastcfilesystem:ClientMount",
      "elasticfilesystem:DescribeFileSystems",
      "elastcfilesystem:ClientWrite",
      "ssm:GetParameter*",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "ghost_policy" {
  name   = "ghost_policy"
  policy = data.aws_iam_policy_document.ghost_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ghost_role" {
  role = aws_iam_role.ghost_role.name
  policy_arn = aws_iam_policy.ghost_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ghost_app"
  role = aws_iam_role.ghost_role.name
}