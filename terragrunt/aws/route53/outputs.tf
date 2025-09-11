output "hosted_zone_id" {
  description = "The hosted zone ID"
  value       = aws_route53_zone.blawx_hosted_zone.id
}

output "hosted_zone_arn" {
  description = "The ARN of the hosted zone"
  value       = aws_route53_zone.blawx_hosted_zone.arn
}

output "hosted_zone_name" {
  description = "The name of the hosted zone"
  value       = aws_route53_zone.blawx_hosted_zone.name
}

output "name_servers" {
  description = "The name servers for the hosted zone"
  value       = aws_route53_zone.blawx_hosted_zone.name_servers
}

output "domain_name" {
  description = "The domain name of the hosted zone"
  value       = aws_route53_zone.blawx_hosted_zone.name
}

output "health_check_id" {
  description = "The ID of the health check (if created)"
  value       = aws_route53_health_check.blawx_health_check.id
}
