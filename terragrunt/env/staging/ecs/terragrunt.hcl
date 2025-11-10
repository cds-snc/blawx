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
    ecr_repository_url = "123456789.dkr.ecr.ca-central-1.amazonaws.com/blawx-staging"
  }
}

dependency "rds" {
  config_path = "../rds"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    rds_cluster_endpoint     = "blawx-staging-database.cluster-abc123.ca-central-1.rds.amazonaws.com"
    rds_cluster_id           = "blawx-staging-database"
    proxy_security_group_id  = "sg-rds123456789"
  }
}

dependency "ssm" {
  config_path = "../ssm"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    parameter_arns = {
      database_password = "arn:aws:ssm:ca-central-1:278626299035:parameter/blawx/staging/database_password"
      database_username = "arn:aws:ssm:ca-central-1:278626299035:parameter/blawx/staging/database_username"
      database_name     = "arn:aws:ssm:ca-central-1:278626299035:parameter/blawx/staging/database_name"
      django_secret_key = "arn:aws:ssm:ca-central-1:278626299035:parameter/blawx/staging/django_secret_key"
    }
    parameter_names = {
      database_password = "/blawx/staging/database_password"
      database_username = "/blawx/staging/database_username"
      database_name     = "/blawx/staging/database_name"
      django_secret_key = "/blawx/staging/django_secret_key"
    }
    additional_parameter_arns = {}
    additional_parameter_names = {}
  }
}

inputs = {
  # Task configuration
  task_cpu      = 2048
  task_memory   = 4096
  desired_count = 1
  
  # Container configuration
  ecr_repository_url = dependency.ecr.outputs.ecr_repository_url
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
      value = "5432" 
    },
    {
      name  = "DEBUG"
      value = "False"
    },
    {
      name  = "ALLOWED_HOSTS"
      value = "blawx.cdssandbox.xyz,localhost,127.0.0.1,0.0.0.0"
    },
    {
      name  = "LOG_LEVEL"
      value = "INFO"
    }
  ]
  
  # Container secrets (from SSM Parameter Store)
  container_secrets = [
    {
      name     = "DATABASE_USER"
      valueFrom = dependency.ssm.outputs.parameter_arns.database_username
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = dependency.ssm.outputs.parameter_arns.database_password
    },
    {
      name      = "DATABASE_NAME"
      valueFrom = dependency.ssm.outputs.parameter_arns.database_name
    },
    {
      name      = "DJANGO_SECRET_KEY"
      valueFrom = dependency.ssm.outputs.parameter_arns.django_secret_key
    }
  ]
  
  # Networking
  vpc_id                 = dependency.vpc.outputs.vpc_id
  private_subnet_ids     = dependency.vpc.outputs.private_subnet_ids
  alb_security_group_id  = dependency.alb.outputs.alb_security_group_id
  proxy_security_group_id  = dependency.rds.outputs.proxy_security_group_id
  
  # Load balancer integration
  lb_target_group_arn = dependency.alb.outputs.target_group_arn
  
  # Auto scaling configuration
  enable_autoscaling       = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 3
  ecs_scale_cpu_threshold  = 70
  ecs_scale_memory_threshold = 80
  
  # CloudWatch logs retention
  log_retention_days = 365
  
  # Enable ECS Exec for debugging in non-production
  enable_execute_command = local.env_vars.inputs.env != "production"
  
  # Platform configuration
  platform_version = "LATEST"
  cpu_architecture = "ARM64"
}
