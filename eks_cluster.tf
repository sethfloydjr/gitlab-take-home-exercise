module "web_eks_cluster" {
  source                          = "./modules/eks_cluster"
  default_region                  = var.default_region
  cluster_name                    = var.cluster_name
  kube_version                    = var.kube_version
  ami_type                        = var.ami_type
  cluster_autoscaler_version      = var.cluster_autoscaler_version
  web_ssh_key                     = aws_key_pair.web_ssh_key.id
  node_pool_config_name           = var.node_pool_config_name
  node_pool_config_machine_type   = var.node_pool_config_machine_type
  node_pool_config_disk_size_gb   = var.node_pool_config_disk_size_gb
  node_pool_config_min_node_count = var.node_pool_config_min_node_count
  node_pool_config_max_node_count = var.node_pool_config_max_node_count
  node_pool_config_capacity_type  = var.node_pool_config_capacity_type
  node_pool_config_purpose        = var.node_pool_config_purpose
  control_plane_log_types         = var.control_plane_log_types
  number_of_zones                 = var.number_of_zones
  scale_down_delay                = var.scale_down_delay
  scale_down_unready              = var.scale_down_unready
  vpc_id                          = module.vpc.vpc_id
  availability_zones              = module.vpc.azs
  network_ipv4_cidr               = var.vpc_cidr
  public_subnets                  = module.vpc.public_subnets
  private_subnets                 = module.vpc.private_subnets
}

// Grab a set of 3 random zones HA
resource "random_shuffle" "available_zones" {
  input        = module.vpc.azs
  result_count = var.number_of_zones
}
