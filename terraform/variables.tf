variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "project_prefix" {
  description = "Prefix used for naming resources"
  type        = string
  default     = "app-mnj"
}

variable "s3_events" {
  description = "List of S3 events that will notify SQS (e.g. s3:ObjectCreated:*)"
  type        = list(string)
  default     = ["s3:ObjectCreated:*"]
}

variable "s3_filter_suffix" {
  description = "Optional suffix filter for S3 events (empty -> no filter). Example: .csv"
  type        = string
  default     = ""
}