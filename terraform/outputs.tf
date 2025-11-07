output "s3_bucket_name" {
  value       = var.bucket_name
  description = "S3 bucket name"
  condition   = var.create_s3
}

output "sqs_queue_url" {
  value       = aws_sqs_queue.app_queue.id
  description = "SQS Queue URL"
}
