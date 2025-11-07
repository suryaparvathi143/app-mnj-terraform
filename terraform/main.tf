# --- Conditionally create S3 bucket ---
resource "aws_s3_bucket" "app_bucket" {
  count  = var.create_s3 ? 1 : 0
  bucket = var.bucket_name
  tags = {
    Name        = var.bucket_name
    Environment = "dev"
  }
}

# --- Create SQS Queue ---
resource "aws_sqs_queue" "app_queue" {
  name                       = var.sqs_queue_name
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10

  tags = {
    Name        = var.sqs_queue_name
    Environment = "dev"
  }
}
