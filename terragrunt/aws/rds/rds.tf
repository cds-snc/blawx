
# RDS Postgresql database for the Blawx app 
#
module "blawx_rds_cluster" {
  source = "github.com/cds-snc/terraform-modules//rds?ref=v10.7.0"
  name   = "${var.product_name}-${var.env}-database"

  database_name  = var.database_name
  engine         = "aurora-postgresql"
  engine_version = "15.12"
  instance_class = "db.t4g.medium"
  instances      = var.database_instances_count
  username       = var.database_username
  password       = var.database_password

  backup_retention_period = 14
  preferred_backup_window = "02:00-04:00"

  vpc_id            = var.vpc_id
  subnet_ids        = var.vpc_private_subnet_ids
  billing_tag_value = var.billing_code
}
