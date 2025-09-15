# KMS encryption
variable "kms_key_id" {
  description = "KMS key ID for encrypting SecureString parameters"
  type        = string
  default     = "alias/aws/ssm"
}

# Database configuration
variable "database_password" {
  description = "Database password for the application"
  type        = string
  sensitive   = true
}

variable "database_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Database name"
  type        = string
  sensitive   = true
}

# Django configuration
variable "django_secret_key" {
  description = "Django secret key for the application"
  type        = string
  sensitive   = true
}


# Additional parameters for flexibility
variable "additional_parameters" {
  description = "Additional SSM parameters to create"
  type = map(object({
    value = string
    type  = string # "String" or "SecureString"
  }))
  default = {}
}
