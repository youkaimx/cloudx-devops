data "aws_iam_policy_document" "name" {
  statement {
    effect        = "Allow"
    actions       = [ 
      "sts:AssumeRole"
      ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_role" {
  name               = "instance_role"
  assume_role_policy = data.aws_iam_policy_document.name.json
}

data "aws_iam_policy_document" "read_secrets" {
 statement {
   effect    = "Allow"
   actions   = [
     "SecretsManager:GetSecretValue",

   ]
   resources = [
     "*"
   ]
 }
}

resource "aws_iam_policy" "read_secrets" {
  name       = "EC2ReadSecrets"
  policy     =  data.aws_iam_policy_document.read_secrets.json
}

resource "aws_iam_role_policy_attachment" "name" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.read_secrets.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name       = "EC2ProfileReadSecrets"
  role       = aws_iam_role.instance_role.name
}