# Some logs from the EKS cluster but could be more robust
# The log group name format is /aws/eks/<cluster-name>/cluster
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 14
}
