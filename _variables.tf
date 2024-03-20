##############################################################################
#                          Authentication                                    #
##############################################################################

variable "default_region" {
  default = "us-east-1"
}

variable "secondary_region" {
  default = "us-west-2"
}


##############################################################################
#                               TAGS VARS                                    #
##############################################################################
#Dynamic tagging done at the provider level. All infr receives these tags when built
variable "Service_Name" {
  default = "Gitlab Take Home"
}

variable "Owning_Team" {
  default = "SRE"
}

variable "Automation" {
  default = "Terraform"
}

variable "Project_Name" {
  default = "gitlab-take-home"
}

#Pulls the path for your code and uses it in a tag
variable "terraform-git-repo" {
  default = "gitlab-take-home-exercise"
}


##############################################################################
#                               VPC VARS                                     #
##############################################################################

variable "vpc_cidr" {
  default = "200.100.0.0/16"
}

variable "vpc_subnets" {
  type = map(list(string))
  default = {
    "azs" = ["us-east-1a", "us-east-1b", "us-east-1c"]
    # 16 available subnets - 4094 IP addresses per subnet
    "private_subnets"  = ["200.100.0.0/20", "200.100.16.0/20", "200.100.32.0/20"]
    "public_subnets"   = ["200.100.48.0/20", "200.100.64.0/20", "200.100.80.0/20"]
    "database_subnets" = ["200.100.96.0/20", "200.100.112.0/20", "200.100.128.0/20"]
  }
}


##############################################################################
#                               EKS VARS                                     #
##############################################################################

variable "cluster_name" {
  default = "web"
}

variable "kube_version" {
  default = "1.23"
}

variable "ami_type" {
  type        = string
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  default     = "AL2_x86_64"
}

variable "cluster_autoscaler_version" {
  default = "v1.21.0"
}

variable "node_pool_config_name" {
  default = "pool1"
}

variable "node_pool_config_disk_size_gb" {
  default = "200"
}

variable "node_pool_config_min_node_count" {
  default = "3"
}

variable "node_pool_config_max_node_count" {
  default = "10"
}

variable "node_pool_config_capacity_type" {
  default = "ON_DEMAND"
}

variable "node_pool_config_purpose" {
  default = "GENERAL"
}

variable "node_pool_config_machine_type" {
  type        = list(string)
  default     = ["c6a.xlarge"]
  description = "c6a.xlarge has 4 vCPU and 8Gb memory"
}

variable "control_plane_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator"]
}
variable "number_of_zones" {
  default = "3"
}

variable "scale_down_delay" {
  description = "How long after a scale up event the Cluster Autoscaler waits before scaling down nodes"
  default     = "240m0s"
}

variable "scale_down_unready" {
  description = "How long the Cluster Autoscaler waits before scaling down unready nodes"
  default     = "5m0s"
}


##############################################################################
#                                S3 VARS                                     #
##############################################################################

variable "web_bucket_prefix" {
  default = "web"
}



##############################################################################
#                               R53 VARS                                     #
##############################################################################
variable "r53_zone_id" {
  description = "Pre-existing domain: setheryops.com"
  default     = "Z2UWQGXD01J8IN"
}

variable "acm_cert_arn" {
  description = "Pre-existing ACM cert: *.setheryops.com"
  default     = "arn:aws:acm:us-east-1:077591943259:certificate/79056b62-57b8-47d0-8ac8-9cde6934b25b"
}
