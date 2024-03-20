provider "aws" {
  alias  = "west"
  region = var.secondary_region
  default_tags {
    tags = {
      "Terraform_Base_Path" = var.Terraform_Base_Path
      "Project_Name"        = var.Project_Name
      "Service_Name"        = var.Service_Name
      "Owning_Team"         = var.Owning_Team
      "Automation"          = var.Automation
    }
  }
}
