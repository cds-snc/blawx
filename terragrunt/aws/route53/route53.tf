resource "aws_route53_zone" "blawx_hosted_zone" {
  name    = var.domain
  comment = "Hosted zone for ${var.product_name} ${var.env} environment"

  tags = {
    Name       = "${var.product_name}-${var.env}-hosted-zone"
    CostCentre = var.billing_tag_value
    Terraform  = true
    Domain     = var.domain
  }
}

# Optional: Create a health check for the domain (useful for monitoring)
resource "aws_route53_health_check" "blawx_health_check" {
  fqdn              = var.domain
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name       = "${var.product_name}-${var.env}-health-check"
    CostCentre = var.billing_tag_value
    Terraform  = true
  }
}
