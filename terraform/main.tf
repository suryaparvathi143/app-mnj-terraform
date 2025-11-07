provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Conditional S3 bucket creation
resource "aws_s3_bucket" "springboot_bucket" {
  count  = var.create_s3 ? 1 : 0
  bucket = var.bucket_name

  tags = {
    Name = "mnj-s3-bucket"
  }
}

# SQS Queue
resource "aws_sqs_queue" "app_queue" {
  name                       = var.sqs_queue_name
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
  delay_seconds              = 0
  fifo_queue                 = false

  tags = {
    Name = "mnj-sqs-queue"
  }
}

# Outputs
output "s3_bucket_name" {
  value = var.create_s3 ? aws_s3_bucket.springboot_bucket[0].id : "S3 bucket already exists"
}

output "sqs_queue_url" {
  value = aws_sqs_queue.app_queue.id
}
