output "task_role" {
  description = "Task role of defined ecs task"
  value       = aws_iam_role.task_role
}