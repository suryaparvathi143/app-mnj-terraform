resource "random_pet" "bucket_suffix" {
  length = 2
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.project_prefix}-bucket-${random_pet.bucket_suffix.id}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name    = "${var.project_prefix}-bucket"
    Project = var.project_prefix
  }
}
