#Module homepage: https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
module "rds" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "web"

  create_db_option_group    = false
  create_db_parameter_group = false

  engine         = "postgres"
  engine_version = "14.1"
  instance_class = "db.t4g.large"

  allocated_storage = 20

  db_name                = "web"
  username               = "web_admin"
  create_random_password = false
  password               = random_password.password.result
  port                   = 5432

  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.vpc.default_security_group_id]

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0
}


# I would rather have this secret be handled by Vault or some other secret manager
resource "aws_ssm_parameter" "web_ssm_parameter" {
  name  = "/web_admin"
  type  = "SecureString"
  value = random_password.password.result
}

resource "random_password" "password" {
  length           = 16
  numeric          = true
  special          = true
  upper            = true
  lower            = true
  override_special = "!#()-=+<>?"
  lifecycle {
    ignore_changes = [
      length,
      lower,
      upper,
      special,
      numeric
    ]
  }
}
