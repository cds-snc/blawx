# Certificate for HTTPS 
resource "aws_acm_certificate" "blawx_certificate" {
  domain_name               = "blawx.cdssandbox.xyz"
  subject_alternative_names = ["*.blawx.cdssandbox.xyz"]
  validation_method         = "DNS"

  tags = {
    "CostCentre" = var.billing_code
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "blawx_certificate_validation" {
  zone_id = var.hosted_zone_id

  for_each = {
    for dvo in aws_acm_certificate.blawx_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type

  ttl = 60
}

resource "aws_acm_certificate_validation" "blawx_certificate" {
  certificate_arn         = aws_acm_certificate.blawx_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.blawx_certificate_validation : record.fqdn]
}


# Security Group for ALB
resource "aws_security_group" "blawx_alb" {
  name_prefix = "${var.product_name}-${var.env}-alb-sg"
  vpc_id      = var.vpc_id
  description = "Security group for ${var.product_name} ${var.env} Application Load Balancer"

  tags = {
    Name       = "${var.product_name}-${var.env}-alb-sg"
    CostCentre = var.billing_tag_value
    Terraform  = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Security Group Rule: HTTPS access from anywhere
resource "aws_security_group_rule" "blawx_alb_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTPS access from anywhere"
  security_group_id = aws_security_group.blawx_alb.id
}

# Security Group Rule: Outbound traffic to application port
resource "aws_security_group_rule" "blawx_alb_egress_app" {
  type              = "egress"
  from_port         = var.app_port
  to_port           = var.app_port
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  description       = "Outbound traffic to port ${var.app_port}"
  security_group_id = aws_security_group.blawx_alb.id
}

# Application Load Balancer
resource "aws_lb" "blawx_alb" {
  name                       = "${var.product_name}-${var.env}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.blawx_alb.id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = var.env == "production" ? true : false
  drop_invalid_header_fields = true

  access_logs {
    bucket  = var.cbs_satellite_bucket_name
    prefix  = "lb_logs"
    enabled = true
  }
  tags = {
    Name       = "${var.product_name}-${var.env}-alb"
    CostCentre = var.billing_tag_value
    Terraform  = true
  }
}

# Target Group for the application
resource "aws_lb_target_group" "blawx_app" {
  name     = "${var.product_name}-${var.env}-app-tg"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    path                = var.health_check_path
    protocol            = "HTTP"
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = {
    Name       = "${var.product_name}-${var.env}-app-target-group"
    CostCentre = var.billing_tag_value
    Terraform  = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# HTTPS Listener
resource "aws_lb_listener" "blawx_https_listener" {
  load_balancer_arn = aws_lb.blawx_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = aws_acm_certificate.blawx_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blawx_app.arn
  }

  tags = {
    Name       = "${var.product_name}-${var.env}-https-listener"
    CostCentre = var.billing_tag_value
    Terraform  = true
  }
}

# Route53 A record pointing to the ALB
resource "aws_route53_record" "blawx_app" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_name
  type    = "A"

  alias {
    name                   = aws_lb.blawx_alb.dns_name
    zone_id                = aws_lb.blawx_alb.zone_id
    evaluate_target_health = true
  }
}
