output "eks_endpoint" {
  value = aws_eks_cluster.web.endpoint
}

output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.web.certificate_authority[0].data
}
