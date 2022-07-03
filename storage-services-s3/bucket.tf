resource "aws_s3_bucket" "this" {
  bucket = "cloudx-devops-epam-merida-s3-lab"
  force_destroy = true
  
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# After enabling versioning you can't disable it:
# │ Error: versioning_configuration.status cannot be updated from 'Enabled' to 'Disabled'

//resource "aws_s3_bucket_versioning" "this" {
//  bucket = aws_s3_bucket.this.id
//  versioning_configuration {
//    status = "Disabled"
//  }
//}

resource "aws_s3_object" "this" {
  for_each = fileset("photos/", "*")
  bucket = aws_s3_bucket.this.id
  key = each.key
  source = "photos/${each.key}"
}

// For the enable versioning part https://catalog.workshops.aws/general-immersionday/en-US/basic-modules/60-s3/s3/5-s3

resource "aws_s3_bucket_versioning" "name" {
  versioning_configuration {
    status = "Enabled"
  }
  bucket = aws_s3_bucket.this.id
}

//For the lifecycle policy https://catalog.workshops.aws/general-immersionday/en-US/basic-modules/60-s3/s3/6-s3
resource "aws_s3_bucket_lifecycle_configuration" "name" {
  bucket = aws_s3_bucket.this.id
  rule {
    id = "cloudx-devops lifecylcle policy"
    filter {
      prefix = "*"
    }
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = "60"
    }

    status = "Enabled"
  }
}
  
