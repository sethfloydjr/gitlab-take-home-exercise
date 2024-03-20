terraform {
  required_version = "> 1.7.0, < 1.8.0"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "> 6.0.0, < 7.0.0"
      configuration_aliases = [aws.west]
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}


provider "aws" {
  region = var.default_region
  default_tags {
    tags = {
      "Terraform_Base_Path" = replace(path.cwd, "/^.*?(${var.terraform-git-repo}\\/)/", "$1")
      "Project_Name"        = var.Project_Name
      "Service_Name"        = var.Service_Name
      "Owning_Team"         = var.Owning_Team
      "Automation"          = var.Automation
    }
  }
}

##########################################################################################

provider "aws" {
  alias  = "west"
  region = var.secondary_region
  default_tags {
    tags = {
      "Terraform_Base_Path" = replace(path.cwd, "/^.*?(${var.terraform-git-repo}\\/)/", "$1")
      "Project_Name"        = var.Project_Name
      "Service_Name"        = var.Service_Name
      "Owning_Team"         = var.Owning_Team
      "Automation"          = var.Automation
    }
  }
}

##########################################################################################

provider "kubernetes" {
  host                   = module.web_eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.web_eks_cluster.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.web_eks_cluster.cluster_id]
  }
}
