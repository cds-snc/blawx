# ECS Module using CDS Terraform Modules

# Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name_prefix = "${var.product_name}-${var.env}-ecs-tasks-sg"
  vpc_id      = var.vpc_id
  description = "Security group for ${var.product_name} ${var.env} ECS tasks"

  tags = {
    Name       = "${var.product_name}-${var.env}-ecs-tasks-sg"
    CostCentre = var.billing_tag_value
    Terraform  = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Security Group Rule: Allow inbound traffic from ALB on container port
resource "aws_security_group_rule" "ecs_tasks_ingress_alb" {
  type                     = "ingress"
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group_id
  description              = "Allow inbound traffic from ALB on port ${var.container_port}"
  security_group_id        = aws_security_group.ecs_tasks.id
}

# Security Group Rule: Allow all outbound traffic
resource "aws_security_group_rule" "ecs_tasks_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.ecs_tasks.id
}

module "ecs" {
  source = "github.com/cds-snc/terraform-modules//ecs?ref=v10.7.0"

  # Cluster Configuration
  cluster_name = "${var.product_name}-${var.env}-cluster"
  service_name = "${var.product_name}-${var.env}-service"

  # Task Configuration
  task_cpu      = var.task_cpu
  task_memory   = var.task_memory
  desired_count = var.desired_count

  # Container Configuration
  container_image       = "${var.ecr_repository_url}:latest"
  container_port        = var.container_port
  container_environment = var.container_environment
  container_secrets     = var.container_secrets

  # Networking
  subnet_ids         = var.private_subnet_ids
  security_group_ids = [aws_security_group.ecs_tasks.id]

  # Load Balancer Integration
  lb_target_group_arn = var.lb_target_group_arn

  # CloudWatch Logs
  cloudwatch_log_group_retention_in_days = var.log_retention_days

  # Auto Scaling
  enable_autoscaling         = var.enable_autoscaling
  autoscaling_min_capacity   = var.autoscaling_min_capacity
  autoscaling_max_capacity   = var.autoscaling_max_capacity
  ecs_scale_cpu_threshold    = var.ecs_scale_cpu_threshold
  ecs_scale_memory_threshold = var.ecs_scale_memory_threshold

  # IAM Roles
  task_role_policy_documents      = var.task_role_policy_documents
  task_exec_role_policy_documents = var.task_exec_role_policy_documents

  # Security & Management
  enable_execute_command = var.enable_execute_command

  # Tags
  billing_tag_value = var.billing_tag_value

  # Platform Configuration
  platform_version = var.platform_version
  cpu_architecture = var.cpu_architecture
}
