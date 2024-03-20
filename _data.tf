data "aws_caller_identity" "current" {}


# FLOW-LOGS BUCKET POLICY
########################################################################

data "aws_iam_policy_document" "flow_logs_bucket_policy" {
  statement {
    sid = "AWSLogDeliveryWrite"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.flow_logs_bucket.arn}/AWSLogs/*"
    ]
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = ["${aws_s3_bucket.flow_logs_bucket.arn}"]
  }
}

