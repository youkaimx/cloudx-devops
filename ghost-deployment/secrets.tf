# Store DB password in a safe way
# Generate DB password and store in SSM Parameter store as secure string(name=/ghost/dbpassw).


# Terraform random_password resource
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "db_password" {
  length = 16
  special = true
}

# Terraform aws_ssm_parameter resource
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter
resource "aws_ssm_parameter" "db_password" {
  name  = "/ghost/dbpassw"
  type  = "SecureString"
  value = random_password.db_password.result
}