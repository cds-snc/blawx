include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env_vars.hcl"))
}

terraform {
  source = "../../../aws//ssm"
}

inputs = {
  # Database configuration
  database_password = "CHANGE_ME_IN_PRODUCTION_USE_ENV_VAR"  # Set via: export TF_VAR_database_password="your-secure-password"
  database_username = "blawx_admin"  # Should match RDS configuration
  database_name     = "blawx_${local.env_vars.inputs.env}"  # Should match RDS database_name

  # Django configuration
  django_secret_key     = "CHANGE_ME_IN_PRODUCTION_USE_ENV_VAR"  # Set via: export TF_VAR_django_secret_key="your-django-secret"

  # Additional environment-specific parameters
  additional_parameters = {
    "cache-timeout" = {
      value = "300"
      type  = "String"
    }
    "max-upload-size" = {
      value = "10485760"  # 10MB in bytes
      type  = "String"
    }
  }
}