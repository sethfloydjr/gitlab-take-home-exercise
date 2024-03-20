# WEB BUCKET POLICY
########################################################################
data "aws_iam_policy_document" "web_replication_policy" {
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    effect = "Allow"

    resources = [
      "${aws_s3_bucket.web_bucket.arn}",
    ]
  }

  statement {
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]

    effect = "Allow"

    resources = [
      "${aws_s3_bucket.web_bucket.arn}/*",
    ]
  }

  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]

    effect = "Allow"

    resources = [
      "${aws_s3_bucket.web_replication_bucket.arn}/*",
    ]
  }
}
