terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}





resource "aws_s3_bucket" "mybucket" {
  bucket = "s3-demo-08122025"
}

# 1) Relax bucket-level Public Access Block
resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket                  = aws_s3_bucket.mybucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 2) Public read policy for objects
data "aws_iam_policy_document" "public_read" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.mybucket.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.mybucket.id
  policy = data.aws_iam_policy_document.public_read.json
  depends_on = [aws_s3_bucket_public_access_block.allow_public]
}
