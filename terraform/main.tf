resource "aws_s3_bucket" "springboot_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "mnj-s3-bucket"
  }
}
