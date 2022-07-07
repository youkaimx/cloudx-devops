resource "aws_s3_bucket" "domain" {
  bucket = "${var.domain}"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.domain.bucket
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    sid = "PublicReadGet"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [ "*" ] 
    }
    actions = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.domain.arn}/*"]

  }
}
resource "aws_s3_bucket_policy" "public_access" {
  policy = data.aws_iam_policy_document.policy_document.json
  bucket = aws_s3_bucket.domain.bucket
}

resource "aws_s3_bucket_website_configuration" "domain" {
  bucket = aws_s3_bucket.domain.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket" "www" {
  bucket = "www.${var.domain}"
}

resource "aws_s3_bucket_website_configuration" "www" {
  bucket = aws_s3_bucket.www.bucket
  redirect_all_requests_to {
    host_name = "${var.domain}"
    protocol = "http"
  }

}
output "domain_endpoint" {
  value = aws_s3_bucket.domain.website_endpoint
}

output "www_endpoint" {
  value = aws_s3_bucket.www.website_endpoint
}

resource "aws_s3_bucket" "logs" {
  bucket = "logs.${var.domain}"
}

resource "aws_s3_bucket_logging" "logs_config" {
  bucket = aws_s3_bucket.domain.bucket
  target_bucket = aws_s3_bucket.logs.bucket
  target_prefix = "logs/"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.domain.bucket
  key = "index.html"
  source = "index.html"
}