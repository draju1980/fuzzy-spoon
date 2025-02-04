variable "region" {
  default = "us-west-1"
}

provider "aws" {
  region  = var.region
  profile = "default"
}

# S3 Bucket for Static Website Hosting
resource "aws_s3_bucket" "website_bucket" {
  bucket        = "0x219ab540356cbb839cbe05303d7705fa" 
  force_destroy = true 
}

# Enable Static Website Hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Public Access Block (Allow Public Read)
resource "aws_s3_bucket_public_access_block" "website_bucket_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket Policy for Public Read Access
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.website_policy.json
}

# Define Public Read Access Policy
data "aws_iam_policy_document" "website_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

# Upload index.html to S3
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "index.html" 
  content_type = "text/html"
}


# Output the Website URL
output "website_url" {
  value       = "http://${aws_s3_bucket.website_bucket.bucket}.s3-website-${var.region}.amazonaws.com"
  description = "The URL of the static website"
}
