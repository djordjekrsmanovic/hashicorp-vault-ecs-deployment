resource "aws_ecs_cluster" "this" {
  name = "${var.environment_name}-cluster"
}

resource "aws_cloudwatch_log_group" "ecs_tasks" {
  name              = "${var.environment_name}-tasks"
  retention_in_days = var.log_retention_in_days
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = var.namespace_name
  description = "Service discovery namespace"
  vpc         = var.vpc_id
}
