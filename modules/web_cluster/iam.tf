# WEB APPLICATION BUCKET
############################################################################
resource "aws_iam_role" "web_replication_role" {
  name = "web_replication"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "web_replication_policy" {
  name   = "web_replication_role"
  policy = data.aws_iam_policy_document.web_replication_policy.json
}

resource "aws_iam_policy_attachment" "web_replication_attachment" {
  name       = "web_replication_attachment"
  roles      = [aws_iam_role.web_replication_role.name]
  policy_arn = aws_iam_policy.web_replication_policy.arn
}


# WEB APPLICATION EC2 INSTANCES
############################################################################
resource "aws_iam_instance_profile" "web_instance_profile" {
  name = "web_instance_profile"
  role = aws_iam_role.web_role.name
}

resource "aws_iam_role" "web_role" {
  name = "web_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "ec2.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}



resource "aws_iam_role_policy_attachment" "web_role_attach" {
  role       = aws_iam_role.web_role.name
  policy_arn = aws_iam_policy.web_iam_policy.arn
}

resource "aws_iam_policy" "web_iam_policy" {
  name   = "web_iam_policy"
  policy = data.aws_iam_policy_document.web_policy_doc.json
}

data "aws_iam_policy_document" "web_policy_doc" {
  statement {
    sid    = "BucketAccess"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.web_bucket.arn}",
      "${aws_s3_bucket.web_bucket.arn}/*"
    ]
  }
}





resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.web_role.name
  policy_arn = aws_iam_policy.web_iam_policy.arn
}
