# This config will use the credentials in the default profile 
# or the ones in the environment, for example the profile pointed at by env var AWS_PROFILE
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
    key = "database-services-rds-basic/terraform.tfstate"
  }
}
