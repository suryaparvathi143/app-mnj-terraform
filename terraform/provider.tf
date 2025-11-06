terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region                   = var.aws_region
  access_key               = var.aws_access_key
  secret_key               = var.aws_secret_key
  shared_credentials_files = []  # disables use of local ~/.aws/credentials
}
