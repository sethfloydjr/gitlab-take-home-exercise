#Pretty basic setup for an EKS cluster.
resource "aws_eks_cluster" "web" {
  name                      = var.cluster_name
  version                   = var.kube_version
  role_arn                  = aws_iam_role.eks_cluster.arn
  enabled_cluster_log_types = var.control_plane_log_types

  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.allow_all.id, aws_security_group.allow_all_within_vpc.id]
  }
  depends_on = [
    aws_iam_role.eks_cluster,
    aws_cloudwatch_log_group.eks_cluster,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController
  ]
}


resource "aws_iam_openid_connect_provider" "web" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.web.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.web.identity[0].oidc[0].issuer
}

