# SSM Parameter Store for Blawx Application Configuration

# Database password parameter
resource "aws_ssm_parameter" "database_password" {
  name        = "/blawx/${var.env}/database_password"
  description = "Database password for Blawx ${var.env} environment"
  type        = "SecureString"
  value       = var.database_password
  key_id      = var.kms_key_id

  tags = {
    Name        = "blawx-${var.env}-database-password"
    Environment = var.env
    CostCentre  = var.billing_tag_value
    Terraform   = true
  }
}

# Database username 
resource "aws_ssm_parameter" "database_username" {
  name        = "/blawx/${var.env}/database_username"
  description = "Database username for Blawx ${var.env} environment"
  type        = "SecureString"
  value       = var.database_username
  key_id      = var.kms_key_id

  tags = {
    Name        = "blawx-${var.env}-database-username"
    Environment = var.env
    CostCentre  = var.billing_tag_value
    Terraform   = true
  }
}

# Database database name 
resource "aws_ssm_parameter" "database_name" {
  name        = "/blawx/${var.env}/database_name"
  description = "Database name for Blawx ${var.env} environment"
  type        = "SecureString"
  value       = var.database_name
  key_id      = var.kms_key_id

  tags = {
    Name        = "blawx-${var.env}-database-name"
    Environment = var.env
    CostCentre  = var.billing_tag_value
    Terraform   = true
  }
}

# Django secret key parameter
resource "aws_ssm_parameter" "django_secret_key" {
  name        = "/blawx/${var.env}/django_secret_key"
  description = "Django secret key for Blawx ${var.env} environment"
  type        = "SecureString"
  value       = var.django_secret_key
  key_id      = var.kms_key_id

  tags = {
    Name        = "blawx-${var.env}-django-secret-key"
    Environment = var.env
    CostCentre  = var.billing_tag_value
    Terraform   = true
  }
}

# Additional application settings
resource "aws_ssm_parameter" "app_settings" {
  for_each = var.additional_parameters

  name        = "/blawx/${var.env}/app/${each.key}"
  description = "Additional parameter ${each.key} for Blawx ${var.env}"
  type        = each.value.type
  value       = each.value.value
  key_id      = each.value.type == "SecureString" ? var.kms_key_id : null

  tags = {
    Name        = "blawx-${var.env}-${each.key}"
    Environment = var.env
    CostCentre  = var.billing_tag_value
    Terraform   = true
  }
}
