# Required variables
variable "hosted_zone_id" {
  description = "The hosted zone ID to create DNS records in"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route53 hosted zone ID that will hold our DNS records"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id of the url shortener"
  type        = string
}

variable "vpc_cidr_block" {
  description = "IP CIDR block of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet ids of the VPC"
  type        = list(string)
}

variable "app_port" {
  description = "The port the application runs on"
  type        = number
  default     = 8000
}

variable "ssl_policy" {
  description = "The SSL policy for the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-3-FIPS-2023-04"
}

# Health check variables
variable "health_check_path" {
  description = "The path for health checks"
  type        = string
  default     = "/health"
}

variable "health_check_matcher" {
  description = "The HTTP status codes for successful health checks"
  type        = string
  default     = "200"
}

variable "health_check_interval" {
  description = "The health check interval in seconds"
  type        = number
  default     = 60
}

variable "health_check_timeout" {
  description = "The health check timeout in seconds"
  type        = number
  default     = 30
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive successful health checks required"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive failed health checks required"
  type        = number
  default     = 3
}
