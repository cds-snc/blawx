# Cluster Outputs
output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs.arn
}

output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

# Service Outputs
output "service_id" {
  description = "ARN of the ECS service"
  value       = module.ecs.service_id
}

output "service_name" {
  description = "Name of the ECS service"
  value       = module.ecs.service_name
}

output "service_port" {
  description = "Port of the ECS service"
  value       = module.ecs.service_port
}

# Task Definition Outputs
output "task_definition_arn" {
  description = "Full ARN of the Task Definition"
  value       = module.ecs.task_definition_arn
}

output "task_definition_family" {
  description = "Family name of the Task Definition"
  value       = module.ecs.task_definition_family
}

output "task_definition_revision" {
  description = "Revision of the Task Definition"
  value       = module.ecs.task_definition_revision
}

# IAM Role Outputs
output "task_role_arn" {
  description = "ARN of the ECS task role"
  value       = module.ecs.task_role_arn
}

output "task_exec_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = module.ecs.task_exec_role_arn
}

# CloudWatch Logs
output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.ecs.cloudwatch_log_group_name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = module.ecs.cloudwatch_log_group_arn
}

# Security Groups
output "ecs_security_group_id" {
  description = "ID of the ECS tasks security group"
  value       = aws_security_group.ecs_tasks.id
}
