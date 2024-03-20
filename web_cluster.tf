#Builds a cluster of EC2 instances that live in an autoscaling group behind a loadbalancer
module "web_ec2_cluster" {
  source              = "./modules/web_cluster"
  Project_Name        = var.Project_Name
  default_region      = var.default_region
  secondary_region    = var.secondary_region
  r53_zone_id         = var.r53_zone_id
  acm_cert_arn        = var.acm_cert_arn
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  private_subnets     = module.vpc.private_subnets
  azs                 = module.vpc.azs
  web_ssh_key         = aws_key_pair.web_ssh_key.id
  Terraform_Base_Path = replace(path.cwd, "/^.*?(${local.terraform-git-repo}\\/)/", "$1")
  Service_Name        = var.Service_Name
  Owning_Team         = var.Owning_Team
  Automation          = var.Automation
}
