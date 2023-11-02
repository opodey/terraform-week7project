resource "aws_s3_bucket" "opodey_state" {
  bucket = "yaw-piesie"  # Replace with your desired bucket name
}

resource "aws_s3_bucket_policy" "nana_access_policy" {
  bucket = aws_s3_bucket.opodey_state.id  # Reference the S3 bucket resource
  
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.opodey_state.arn,
          "${aws_s3_bucket.opodey_state.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "8.8.8.8/32"
          }
        }
      },
    ]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_config" {
  bucket = aws_s3_bucket.opodey_state.id

  rule {
    id      = "enable-versioning"
    status  = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days =  180
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days =  365
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  depends_on = [aws_s3_bucket.opodey_state]
}
