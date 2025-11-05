provider "aws" {
  region = var.aws_region
  # Credentials are intentionally not hardcoded.
  # Terraform will read credentials from:
  # - Environment variables: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN
  # - Or AWS CLI configured profile (AWS_PROFILE)
  # - Or IAM role attached to the Jenkins/EC2 instance (instance profile)
}
