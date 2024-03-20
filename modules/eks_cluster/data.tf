data "tls_certificate" "web" {
  url = aws_eks_cluster.web.identity[0].oidc[0].issuer
}

data "aws_caller_identity" "web" {}

data "aws_iam_policy_document" "assume_cluster_autoscaler" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.web.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.web.arn]
      type        = "Federated"
    }
  }
}
