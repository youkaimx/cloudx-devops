data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.this.arn}/*" ]
  }

  statement {
    effect = "Allow"
    actions = [ "s3:ListBucket" ]
    resources = [ "${aws_s3_bucket.this.arn}" ]
  } 
}

resource "aws_iam_policy" "bucket_read" {
  name = "cloudx-devops-storage-services-s3-policy"
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role" "this" {
  name = "cloudx-devops-storage-services-s3-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.this.name
  policy_arn = aws_iam_policy.bucket_read.arn
}
  
resource "aws_iam_instance_profile" "name" {
  name = "s3_read_instance_profile"
  role = aws_iam_role.this.name
}
