output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.blawx_ecr.repository_url
}

output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.blawx_ecr.name
}

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  value       = aws_ecr_repository.blawx_ecr.arn
}

output "ecr_registry_id" {
  description = "The registry ID where the repository was created"
  value       = aws_ecr_repository.blawx_ecr.registry_id
}
