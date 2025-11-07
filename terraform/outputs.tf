output "s3_bucket_name" {
  description = "S3 bucket name (if created)"
  value       = var.create_s3 ? var.bucket_name : "S3 bucket creation skipped"
}

output "sqs_queue_url" {
  description = "SQS Queue URL"
  value       = aws_sqs_queue.app_queue.id
}
