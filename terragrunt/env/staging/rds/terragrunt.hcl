include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env_vars.hcl"))
}

terraform {
  source = "../../../aws//rds"
}

# Dependencies - RDS needs VPC to exist first
dependencies {
  paths = ["../vpc"]
}

dependency "vpc" {
  config_path = "../vpc"
 
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    vpc_id                = "vpc-123456789"
    private_subnet_ids    = ["subnet-123456789", "subnet-987654321"]
    public_subnet_ids     = ["subnet-111111111", "subnet-222222222"]
    vpc_cidr_block        = "10.0.0.0/16"
  }
}

inputs = {
  # Environment configuration
  product_name   = local.env_vars.inputs.product_name
  env           = local.env_vars.inputs.env
  billing_code  = "blawx-${local.env_vars.inputs.env}"
  
  # Networking
  vpc_id                   = dependency.vpc.outputs.vpc_id
  vpc_private_subnet_ids   = dependency.vpc.outputs.private_subnet_ids
  
  # Database configuration
  database_name            = "blawx_${local.env_vars.inputs.env}"
  database_username        = "blawx_admin"
  database_password        = "CHANGE_ME_IN_PRODUCTION_USE_SECRETS_MANAGER"
  database_instances_count = 1
}
