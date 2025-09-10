include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env_vars.hcl"))
}

terraform {
  source = "../../../aws//alb"
}

# Dependencies - ALB needs VPC and Route53 to exist first
dependencies {
  paths = ["../vpc", "../route53"]
}

dependency "vpc" {
  config_path = "../vpc"
 
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    vpc_id 		   = "vpc-123456789"
    vpc_private_subnet_ids = ["subnet-123456789", "subnet-987654321"]
    vpc_public_subnet_ids  = ["subnet-111111111", "subnet-222222222"]
    vpc_cidr_block         = "10.0.0.0/16"
  }
}

dependency "route53" {
  config_path = "../route53"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    hosted_zone_id   = "Z1234567890ABC"
    hosted_zone_name = "blawx.cdssandbox.xyz"
  }
}

inputs = {
  hosted_zone_id     	    = dependency.route53.outputs.hosted_zone_id
  hosted_zone_name     	  = dependency.route53.outputs.hosted_zone_name
  vpc_id	     	          = dependency.vpc.outputs.vpc_id
  vpc_private_subnet_ids  = dependency.vpc.outputs.vpc_private_subnet_ids
  vpc_public_subnet_ids   = dependency.vpc.outputs.vpc_public_subnet_ids
  vpc_cidr_block     	    = dependency.vpc.outputs.vpc_cidr_block

  # Environment variables
  product_name      = local.env_vars.inputs.product_name
  env               = local.env_vars.inputs.env
  billing_code      = "blawx-${local.env_vars.inputs.env}"
  billing_tag_value = "blawx-${local.env_vars.inputs.env}"
} 