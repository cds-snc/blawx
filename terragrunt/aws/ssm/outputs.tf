# SSM Parameter ARNs
output "parameter_arns" {
  description = "Map of all SSM parameter ARNs"
  value = {
    database_password = aws_ssm_parameter.database_password.arn
    database_username = aws_ssm_parameter.database_username.arn
    database_name     = aws_ssm_parameter.database_name.arn
    django_secret_key = aws_ssm_parameter.django_secret_key.arn
  }
}

# SSM Parameter Names
output "parameter_names" {
  description = "Map of all SSM parameter names"
  value = {
    database_password = aws_ssm_parameter.database_password.name
    database_username = aws_ssm_parameter.database_username.name
    database_name     = aws_ssm_parameter.database_name.name
    django_secret_key = aws_ssm_parameter.django_secret_key.name
  }
}

# Additional parameters outputs
output "additional_parameter_arns" {
  description = "ARNs of additional SSM parameters"
  value       = { for k, v in aws_ssm_parameter.app_settings : k => v.arn }
}

output "additional_parameter_names" {
  description = "Names of additional SSM parameters"
  value       = { for k, v in aws_ssm_parameter.app_settings : k => v.name }
}
