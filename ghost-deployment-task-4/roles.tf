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

resource "aws_iam_role_policy_attachment" "ghost_role_two" {
  role = aws_iam_role.ghost_ecs_tasks_role.name
  policy_arn =  "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

### Task 4
# 4 - Create IAM role
# Create IAM Role and associated IAM Role profile (name=ghost_ecs) with the following permissions:
# "ecr:GetAuthorizationToken",
# "ecr:BatchCheckLayerAvailability",
# "ecr:GetDownloadUrlForLayer",
# "ecr:BatchGetImage",
# "elasticfilesystem:DescribeFileSystems",
# "elasticfilesystem:ClientMount",
# "elasticfilesystem:ClientWrite"
# This IAM role now provides ECS Tasks with access to the services. For test purposes it acceptable to allow "any" 
# resource access. You would consider to restrict each service in policy with 
# resource arn(using separate statement for each service) in the real environments.
data "aws_iam_policy_document" "ghost_ecs_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ghost_ecs_tasks_role" {
  name               = "ghost_ecs_tasks_role"
  assume_role_policy = data.aws_iam_policy_document.ghost_ecs_assume_role_policy.json
}

data "aws_iam_policy_document" "ghost_ecs_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
# See short description in https://aws.amazon.com/premiumsupport/knowledge-center/ecs-unable-to-pull-secrets/
      "ssm:GetParameters", 
      "secretsmanager:GetSecretValue", 
      "kms:Decrypt"
    ]
    resources = [ "*" ]
  }
}

resource "aws_iam_policy" "ecs_ghost_policy" {
  name = "ecs_ghost"
  policy = data.aws_iam_policy_document.ghost_ecs_policy_document.json
}

resource "aws_iam_role_policy_attachment" "name" {
  role = aws_iam_role.ghost_ecs_tasks_role.id
  policy_arn = aws_iam_policy.ecs_ghost_policy.arn
}

resource "aws_iam_role_policy_attachment" "name2" {
  role = aws_iam_role.ghost_ecs_tasks_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}