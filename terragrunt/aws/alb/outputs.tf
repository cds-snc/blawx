output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.blawx_alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.blawx_alb.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the Application Load Balancer"
  value       = aws_lb.blawx_alb.zone_id
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.blawx_alb.id
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.blawx_app.arn
}

output "target_group_name" {
  description = "The name of the target group"
  value       = aws_lb_target_group.blawx_app.name
}

output "https_listener_arn" {
  description = "The ARN of the HTTPS listener"
  value       = aws_lb_listener.blawx_https_listener.arn
}

output "certificate_arn" {
  description = "The ARN of the SSL certificate"
  value       = aws_acm_certificate.blawx_certificate.arn
}

output "route53_record_name" {
  description = "The name of the Route53 record"
  value       = aws_route53_record.blawx_app.name
}

output "route53_record_fqdn" {
  description = "The FQDN of the Route53 record"
  value       = aws_route53_record.blawx_app.fqdn
}