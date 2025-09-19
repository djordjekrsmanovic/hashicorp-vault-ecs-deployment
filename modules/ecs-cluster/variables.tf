variable "environment_name" {
  description = "Name of the environment (e.g. dev, test, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where namespace will be created"
  type        = string
}

variable "namespace_name" {
  description = "Service discovery namespace"
  type        = string
  default     = "retailstore.local"
}

variable "log_retention_in_days" {
  description = "Retention period for CloudWatch logs"
  type        = number
  default     = 30
}


