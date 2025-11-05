# SQS queue
resource "aws_sqs_queue" "app_queue" {
  name                       = "${var.project_prefix}-s3-queue-${random_pet.bucket_suffix.id}"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 1209600  # 14 days
  tags = {
    Project = var.project_prefix
  }
}

# Build policy JSON that allows s3.amazonaws.com to SendMessage to this queue
data "aws_iam_policy_document" "s3_to_sqs" {
  statement {
    sid = "AllowS3SendMessage"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sqs:SendMessage"]

    resources = [aws_sqs_queue.app_queue.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.app_bucket.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "allow_s3" {
  queue_url = aws_sqs_queue.app_queue.id
  policy    = data.aws_iam_policy_document.s3_to_sqs.json
}
# Configure S3 bucket notification to send events to SQS.
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.app_bucket.id

  queue {
    queue_arn = aws_sqs_queue.app_queue.arn
    events    = var.s3_events

    # Optional filter, applied only if suffix is provided
    dynamic "filter" {
      for_each = var.s3_filter_suffix != "" ? [1] : []
      content {
        key {
          filter_rules {
            name  = "suffix"
            value = var.s3_filter_suffix
          }
        }
      }
    }
  }

  depends_on = [aws_sqs_queue_policy.allow_s3]
}
