provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  shared_credentials_file = ""  # ignore ~/.aws/credentials completely
}
