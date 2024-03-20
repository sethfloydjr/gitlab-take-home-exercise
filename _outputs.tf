
################################################################################
#                            VPC OUTPUTS
################################################################################
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "availability_zones" {
  description = "List of availability_zones available for the VPC"
  value       = module.vpc.azs
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}



################################################################################
#                                WEB EC2 OUTPUTS
################################################################################
output "web_lb_dns_name" {
  description = "DNS name of the loadbalancer that a route53 points to to resolve the website in the EC2 web cluster."
  value       = module.web_ec2_cluster.web_lb_dns_name
}



################################################################################
#                            POSTGRESQL OUTPUTS
################################################################################

output "rds_id" {
  value = module.rds.db_instance_id
}

output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "rds_instance_address" {
  value = module.rds.db_instance_address
}




################################################################################
#                            EKS OUTPUTS
################################################################################

output "eks_endpoint" {
  value = module.web_eks_cluster.eks_endpoint
}

