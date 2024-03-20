resource "aws_eks_node_group" "web" {
  cluster_name    = aws_eks_cluster.web.name
  node_group_name = var.node_pool_config_name
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.private_subnets
  ami_type        = var.ami_type
  capacity_type   = var.node_pool_config_capacity_type
  disk_size       = var.node_pool_config_disk_size_gb
  instance_types  = var.node_pool_config_machine_type #Determines the vCPU and Memory(Gb) of the nodes in the node group


  remote_access {
    ec2_ssh_key               = var.web_ssh_key
    source_security_group_ids = [aws_security_group.allow_all.id, aws_security_group.allow_all_within_vpc.id]
  }

  scaling_config {
    desired_size = var.node_pool_config_min_node_count
    min_size     = var.node_pool_config_min_node_count
    max_size     = var.node_pool_config_max_node_count
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryPowerUser,
    aws_iam_role_policy_attachment.AmazonS3FullAccess
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size, version]
  }
  labels = {
    "node-group" = var.node_pool_config_name
  }
  # Required for autoscaling
  tags = merge({
  Name = "${var.node_pool_config_name}", Purpose = "${var.node_pool_config_purpose}", "k8s.io/cluster-autoscaler/enabled" = "TRUE", "k8s.io/cluster-autoscaler/${aws_eks_cluster.web.name}" = "owned" })
  timeouts {
    create = "10m"
    delete = "20m"
  }
}
