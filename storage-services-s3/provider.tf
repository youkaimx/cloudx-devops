provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      ProvisionedBy = "Terraform"
      Project       = "CloudX Associate: AWS DevOps"
    }
  }
}

terraform {
  backend "s3" {
    region = "us-east-2"
    bucket = "cloudx-associate-devops-tf"
    key = "storage-services-s3/terraform.tfstate"
  }
}
