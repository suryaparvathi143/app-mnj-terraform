variable "bucket_name" {
  description = "Name of the S3 bucket to be created"
  type        = string
}

variable "sqs_queue_name" {
  description = "Name of the SQS queue to be created"
  type        = string
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}

variable "create_s3" {
  description = "Flag to control S3 bucket creation"
  type        = bool
  default     = true
}
