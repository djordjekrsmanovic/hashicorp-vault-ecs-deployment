variable "name" {
  type        = string
  description = "Base name for ALB and resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where ALB will be deployed"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets IDs for the ALB"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}


variable "target_port" {
  type        = number
  default     = 8080
}

variable "target_protocol" {
  type        = string
  default     = "HTTP"
}

variable "certificate_arn" {
  type        = string
}
