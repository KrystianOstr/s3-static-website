resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = local.tags
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_owner_controls" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_pub_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false #allow pub policy
  restrict_public_buckets = false #allow pub bucket
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website_config" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

data "aws_iam_policy_document" "s3_public_read" {
  statement {
    sid = "AllowPublicReadForWebsite"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*"
    ]

  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = data.aws_iam_policy_document.s3_public_read.json
}

resource "aws_s3_object" "site_files" {
  for_each = { for file in local.files : file => file }

  bucket = aws_s3_bucket.s3_bucket.id
  key    = each.key
  source = "${local.site_path}/${each.key}"
  content_type = lookup(
    {
      html  = "text/html"
      css   = "text/css"
      js    = "application/javascript"
      png   = "image/png"
      jpg   = "image/jpeg"
      jpeg  = "image/jpeg"
      gif   = "image/gif"
      svg   = "image/svg+xml"
      ico   = "image/x-icon"
      json  = "application/json"
      woff  = "font/woff"
      woff2 = "font/woff2"
      ttf   = "font/ttf"
    },
    lower(split(".", each.key)[length(split(".", each.key)) - 1]),
    "binary/octet-stream"
  )

}

