# Task Configuration
variable "task_cpu" {
  description = "Number of CPU units used by the task (256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Amount (in MiB) of memory used by the task"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}

# Container Configuration
variable "ecr_repository_url" {
  description = "URL of the Saas Procurement ECR"
  type        = string
}

variable "container_port" {
  description = "Port that the container exposes"
  type        = number
  default     = 8000
}

# Container Environment and Secrets
variable "container_environment" {
  description = "List of environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "container_secrets" {
  description = "List of secrets for the container from SSM Parameter Store"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

# Networking
variable "vpc_id" {
  description = "ID of the VPC where ECS tasks will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet ids of the Blawx VPC"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID of the Application Load Balancer"
  type        = string
}

variable "rds_security_group_id" {
  description = "Security group ID of the RDS database"
  type        = string
}

# Load Balancer
variable "lb_target_group_arn" {
  description = "ARN of the load balancer target group to register the service with"
  type        = string
  default     = null
}

# CloudWatch Logs
variable "log_retention_days" {
  description = "Number of days to retain log events in CloudWatch"
  type        = number
  default     = 30
}

# Auto Scaling
variable "enable_autoscaling" {
  description = "Whether to enable auto scaling for the ECS service"
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of tasks for auto scaling"
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of tasks for auto scaling"
  type        = number
  default     = 2
}

variable "ecs_scale_cpu_threshold" {
  description = "CPU utilization threshold that triggers scaling"
  type        = number
  default     = 70
}

variable "ecs_scale_memory_threshold" {
  description = "Memory utilization threshold that triggers scaling"
  type        = number
  default     = 80
}

# IAM Policies
variable "task_role_policy_documents" {
  description = "List of IAM policy documents to attach to the task role"
  type        = list(any)
  default     = []
}

variable "task_exec_role_policy_documents" {
  description = "List of IAM policy documents to attach to the task execution role"
  type        = list(any)
  default     = []
}

# Security & Management
variable "enable_execute_command" {
  description = "Enable ECS Exec for debugging and troubleshooting"
  type        = bool
  default     = false
}

# Platform Configuration
variable "platform_version" {
  description = "Platform version on which to run the service"
  type        = string
  default     = "LATEST"
}

variable "cpu_architecture" {
  description = "CPU architecture for the task (X86_64 or ARM64)"
  type        = string
  default     = "X86_64"

  validation {
    condition     = contains(["X86_64", "ARM64"], var.cpu_architecture)
    error_message = "CPU architecture must be either X86_64 or ARM64."
  }
}
