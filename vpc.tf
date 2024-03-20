#Module homepage:  https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/
module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  version                      = "~> 3.16.0"
  name                         = "gitlab"
  cidr                         = var.vpc_cidr
  azs                          = lookup(var.vpc_subnets, "azs")
  private_subnets              = lookup(var.vpc_subnets, "private_subnets")
  public_subnets               = lookup(var.vpc_subnets, "public_subnets")
  database_subnets             = lookup(var.vpc_subnets, "database_subnets")
  create_database_subnet_group = true
  enable_nat_gateway           = true
  enable_dns_support           = true
  enable_dns_hostnames         = true
  enable_flow_log              = true
  flow_log_destination_type    = "s3"
  flow_log_destination_arn     = aws_s3_bucket.flow_logs_bucket.arn
}


# FLOW LOGS BUCKET
# Used for viewing VPC traffic logs to help with troubleshooting network issues
############################################################################

resource "aws_s3_bucket" "flow_logs_bucket" {
  bucket = "gitlab-vpc-flow-logs"
}

resource "aws_s3_bucket_policy" "flow_logs_bucket_access" {
  bucket = aws_s3_bucket.flow_logs_bucket.id
  policy = data.aws_iam_policy_document.flow_logs_bucket_policy.json
}

resource "aws_s3_bucket_versioning" "flow_logs_bucket_versioning" {
  bucket = aws_s3_bucket.flow_logs_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "flow_logs_bucket_lifecycle" {
  bucket = aws_s3_bucket.flow_logs_bucket.id

  rule {
    id     = "rule-1"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
    noncurrent_version_expiration {
      noncurrent_days = 3
    }
    transition {
      days          = 60
      storage_class = "ONEZONE_IA"
    }
  }
}

resource "aws_s3_bucket_acl" "flow_logs_bucket_acl" {
  bucket = aws_s3_bucket.flow_logs_bucket.id
  acl    = "private"
}

