output "file_system_id" {
  description = "EFS file system ID"
  value       = aws_efs_file_system.this.id
}

output "access_point_id" {
  description = "EFS access point ID"
  value       = aws_efs_access_point.this.id
}

output "security_group_id" {
  description = "Security group for EFS"
  value       = aws_security_group.efs.id
}
