output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.this.name
}

output "ecs_cluster_arn" {
   description = "ECS Cluster Arn"
  value = aws_ecs_cluster.this.arn
}

output "service_discovery_namespace_arn" {
   description = "Service Discovery Arn"
  value = aws_service_discovery_private_dns_namespace.this.arn
}

output "log_group_name" {
  description = "CloudWatch log group name for ECS tasks"
  value       = aws_cloudwatch_log_group.ecs_tasks.name
}

output "log_group_arn" {
  description = "CloudWatch log group ARN for ECS tasks"
  value       = aws_cloudwatch_log_group.ecs_tasks.arn
}

output "log_group_id" {
  description = "CloudWatch log group ARN for ECS tasks"
  value       = aws_cloudwatch_log_group.ecs_tasks.id
}

output "namespace_id" {
  description = "Service discovery namespace ID"
  value       = aws_service_discovery_private_dns_namespace.this.id
}
