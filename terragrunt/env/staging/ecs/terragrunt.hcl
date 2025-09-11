include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env_vars.hcl"))
}

terraform {
  source = "../../../aws//ecs"
}

# Dependencies - ECS needs VPC, ALB, ECR, RDS, and SSM to exist first
dependencies {
  paths = ["../vpc", "../alb", "../ecr", "../rds", "../ssm"]
}

dependency "vpc" {
  config_path = "../vpc"
 
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    vpc_id                 = "vpc-123456789"
    private_subnet_ids     = ["subnet-123456789", "subnet-987654321"]
    public_subnet_ids      = ["subnet-111111111", "subnet-222222222"]
    vpc_cidr_block         = "10.0.0.0/16"
  }
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    target_group_arn         = "arn:aws:elasticloadbalancing:ca-central-1:278626299035:targetgroup/blawx-staging-app-tg/12345"
    alb_security_group_id    = "sg-123456789"
    alb_dns_name            = "blawx-staging-alb-123456789.ca-central-1.elb.amazonaws.com"
  }
}

dependency "ecr" {
  config_path = "../ecr"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    repository_url = "123456789.dkr.ecr.ca-central-1.amazonaws.com/blawx-staging"
  }
}

dependency "rds" {
  config_path = "../rds"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    rds_cluster_endpoint     = "blawx-staging-database.cluster-abc123.ca-central-1.rds.amazonaws.com"
    rds_cluster_port         = "5432"
    rds_cluster_database_name = "blawx_staging"
    rds_cluster_master_username = "blawx_admin"
    rds_security_group_id    = "sg-rds123456789"
  }
}

dependency "ssm" {
  config_path = "../ssm"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    parameter_names = {
      database_password    = "/blawx/staging/database/password"
      django_secret_key   = "/blawx/staging/django/secret-key"
      django_debug        = "/blawx/staging/django/debug"
      django_allowed_hosts = "/blawx/staging/django/allowed-hosts"
      app_environment     = "/blawx/staging/app/environment"
      log_level          = "/blawx/staging/app/log-level"
    }
  }
}

inputs = {
  # Environment configuration
  product_name      = local.env_vars.inputs.product_name
  env              = local.env_vars.inputs.env
  billing_tag_value = "blawx-${local.env_vars.inputs.env}"
  
  # Task configuration
  task_cpu      = 512
  task_memory   = 1024
  desired_count = 1
  
  # Container configuration
  ecr_repository_url = dependency.ecr.outputs.repository_url
  container_port     = 8000
  
  # Container environment variables
  container_environment = [
    {
      name  = "ENVIRONMENT"
      value = local.env_vars.inputs.env
    },
    {
      name  = "PORT"
      value = "8000"
    },
    {
      name  = "DATABASE_HOST"
      value = dependency.rds.outputs.rds_cluster_endpoint
    },
    {
      name  = "DATABASE_PORT"
      value = tostring(dependency.rds.outputs.rds_cluster_port)
    },
    {
      name  = "DATABASE_NAME"
      value = dependency.rds.outputs.rds_cluster_database_name
    },
    {
      name  = "DATABASE_USER"
      value = dependency.rds.outputs.rds_cluster_master_username
    }
  ]
  
  # Container secrets (from SSM Parameter Store)
  container_secrets = [
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = dependency.ssm.outputs.parameter_names.database_password
    },
    {
      name      = "DJANGO_SECRET_KEY"
      valueFrom = dependency.ssm.outputs.parameter_names.django_secret_key
    },
    {
      name      = "DEBUG"
      valueFrom = dependency.ssm.outputs.parameter_names.django_debug
    },
    {
      name      = "ALLOWED_HOSTS"
      valueFrom = dependency.ssm.outputs.parameter_names.django_allowed_hosts
    },
    {
      name      = "LOG_LEVEL"
      valueFrom = dependency.ssm.outputs.parameter_names.log_level
    }
  ]
  
  # Networking
  vpc_id                 = dependency.vpc.outputs.vpc_id
  private_subnet_ids     = dependency.vpc.outputs.private_subnet_ids
  alb_security_group_id  = dependency.alb.outputs.alb_security_group_id
  rds_security_group_id  = dependency.rds.outputs.rds_security_group_id
  
  # Load balancer integration
  lb_target_group_arn = dependency.alb.outputs.target_group_arn
  
  # Auto scaling configuration
  enable_autoscaling       = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 3
  ecs_scale_cpu_threshold  = 70
  ecs_scale_memory_threshold = 80
  
  # CloudWatch logs retention
  log_retention_days = 30
  
  # Enable ECS Exec for debugging in non-production
  enable_execute_command = local.env_vars.inputs.env != "production"
  
  # Platform configuration
  platform_version = "LATEST"
  cpu_architecture = "X86_64"
}
