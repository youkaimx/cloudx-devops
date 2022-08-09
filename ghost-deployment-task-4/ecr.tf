# 3 - Create ECR
# Create ECR related resources:
# ECR repository:
# name=ghost, Tag immutability = disabled,
# Scan on push = disabled, KMS encryption = disabled
resource "aws_ecr_repository" "ghost" {
  name = "ghost"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}

# *Upload ghost:4.12 image into ghost ECR
# Pull public accessable ghost:4.12 docker image
# Login into <account_id>.dkr.ecr.<region>.amazonaws.com
# Tag pulled image with <account_id>.dkr.ecr.<region>.amazonaws.com/ghost:4.12
# Push <account_id>.dkr.ecr.<region>.amazonaws.com/ghost:4.12
# * - Image size is expected to be less than 500 M

resource "aws_cloudwatch_log_group" "ghost_log_group" {
  name = "ghost_log_group"
  retention_in_days = 3
}
