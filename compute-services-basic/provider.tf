provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      ProvisionedBy = "Terraform"
      Project       = "CloudX Associate: AWS DevOps"
#      Date          = "${formatdate("DD MMM YYYY", timestamp())}"
    }
  }
}

terraform {
  backend "s3" {
    region = "us-east-2"
    bucket = "cloudx-associate-devops-tf"
    key = "compute-services-basic/terraform.tfstate"
  }
}
