# WEB APPLICATION BUCKET
############################################################################

resource "aws_s3_bucket" "web_bucket" {
  bucket = "${var.Project_Name}-${var.default_region}"
}

resource "aws_s3_bucket_versioning" "web_bucket_versioning" {
  bucket = aws_s3_bucket.web_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "web_bucket_replication" {
  depends_on = [aws_s3_bucket_versioning.web_bucket_versioning]

  role   = aws_iam_role.web_replication_role.arn
  bucket = aws_s3_bucket.web_bucket.id

  rule {
    id = "replication_rule"

    filter {
      prefix = ""
    }

    delete_marker_replication {
      status = "Enabled"
    }

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.web_replication_bucket.arn
      storage_class = "STANDARD_IA"
    }
  }
}

#Replication Bucket
resource "aws_s3_bucket" "web_replication_bucket" {
  provider = aws.west
  bucket   = "${var.Project_Name}-${var.secondary_region}"
}

resource "aws_s3_bucket_versioning" "web_replication_bucket_versioning" {
  provider = aws.west
  bucket   = aws_s3_bucket.web_replication_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
