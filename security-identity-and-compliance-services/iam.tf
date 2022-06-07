# Reference
# https://catalog.workshops.aws/general-immersionday/en-US/basic-modules/30-iam/iam/2-iam#create-aws-iam-identities


# 4. When defining policy for the AWS permissions, you can create and edit in visual editor or JSON.
# In this lab, we will use JSON method. Briefly describe the permission below, this policy allows
# all actions for EC2 tagged as Env-dev. Also, it allows describe-related actions for all EC2 
# instances. But it denies create and delete tags action to prevent users from modifying tags
# arbitrarily. Note that deny effect takes precedence over allow effect.

data "aws_iam_policy_document" "devpolicy_doc" {
  version = "2012-10-17"
  statement {
    actions = [ "ec2:*" ]
    effect = "Allow"
    resources = [ "*" ]
    condition {
      test = "StringEquals"
      variable = "ec2:ResourceTag/Env"
      values = [ "dev"]
    }
  }

  statement {
    effect = "Allow"
    actions = [ "ec2:Describe*"]
    resources = [ "*" ]
  }

  statement {
    effect = "Deny"
    actions = [
      "ec2:DeleteTags",
      "ec2:CreateTags"
    ]
    resources = [ "*" ]
  }
}

resource "aws_iam_policy" "dev_policy" {
  policy = data.aws_iam_policy_document.devpolicy_doc.json
  name   = "DevPolicy"
  description = "IAM Policy for Dev Group"
}

resource "aws_iam_group" "dev_group" {
  name = "dev-group"
}

resource "aws_iam_group_policy_attachment" "dev_policy_dev_group_attachment" {
  group =  aws_iam_group.dev_group.name 
  policy_arn = aws_iam_policy.dev_policy.arn
}

resource "aws_iam_user" "dev_user" {
  name = "dev-user"
}

resource "aws_iam_group_membership" "dev_group_membership" {
  name  = "dev-group-membership"
  group = aws_iam_group.dev_group.name
  users = [
    aws_iam_user.dev_user.name
  ]
}

resource "aws_iam_access_key" "dev_user_programmatic_access" {
  user = aws_iam_user.dev_user.name
}

resource "aws_iam_user_login_profile" "dev_user_login" {
  user = aws_iam_user.dev_user.name

}

output "dev_user_acess_key_id" {
  value = aws_iam_access_key.dev_user_programmatic_access.id
}


output "dev_user_secret_key" {
  value = aws_iam_access_key.dev_user_programmatic_access.secret
  sensitive = true
}

output "dev_user_console_access" {
  value = aws_iam_user_login_profile.dev_user_login.password
  sensitive = true
}